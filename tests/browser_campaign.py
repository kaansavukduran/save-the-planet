"""Real browser, keyboard, WebGL and Godot physics. Read-only QA telemetry; never inject progress."""
from browser_wait import wait_js
from browser_runtime import CHROMIUM
from virtual_gamepad import VirtualGamepad
from touch_driver import TouchDriver
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json,time,os
ROOT=Path(__file__).resolve().parents[1]
LEVELS=json.loads((ROOT/'data/levels.json').read_text());TARGET_COUNT=int(os.environ.get('STP_TEST_LEVELS','10'))
class Quiet(SimpleHTTPRequestHandler):
 def log_message(self,*args):pass
PORT=int(os.environ.get('STP_TEST_PORT','8013'));LANGUAGE=os.environ.get('STP_TEST_LANGUAGE','tr');DEVICE=os.environ.get('STP_TEST_INPUT','keyboard');EVIDENCE=ROOT/'docs/evidence/v0.4'/(DEVICE+'-'+LANGUAGE+'-'+os.environ.get('STP_TEST_VIEWPORT','1152x648'));EVIDENCE.mkdir(parents=True,exist_ok=True)
server=ThreadingHTTPServer(('127.0.0.1',PORT),partial(Quiet,directory=str(ROOT/'build/web-qa')))
Thread(target=server.serve_forever,daemon=True).start()
errors=[];checks=[];snaps=[];started=time.monotonic()
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 width,height=map(int,os.environ.get('STP_TEST_VIEWPORT','1152x648').split('x'))
 page=b.new_page(viewport={'width':width,'height':height},has_touch=DEVICE=='touch');page.set_default_timeout(15000)
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None)
 page.on('pageerror',lambda e:errors.append(str(e)))
 driver=VirtualGamepad(page) if DEVICE=='gamepad' else (TouchDriver(page) if DEVICE=='touch' else page.keyboard)
 held=set()
 def hold(key,yes):
  if yes and key not in held:driver.down(key);held.add(key)
  elif not yes and key in held:driver.up(key);held.remove(key)
 def release():
  for k in list(held):hold(k,False)
 def state():return page.evaluate('window.__planetQA')
 def check(ok,label):
  checks.append({'check':label,'pass':bool(ok)});print(label,ok,flush=True)
 def close_menu():
  s=state()
  if s['menu']!='':release();driver.press('Escape');page.wait_for_timeout(180)
 def walk(target):
  last_x=None;stuck=0;jump_start=None;second=False;trace=0;deadline=time.monotonic()+(120 if DEVICE=="touch" else 48)
  while time.monotonic()<deadline:
   s=state()
   if s['menu']!='':close_menu();continue
   x=s['x'];dist=target-x
   if abs(dist)<(46 if DEVICE=='touch' else 21):
    release();driver.down('s');page.wait_for_timeout(650);driver.up('s')
    # Gamepad polling and platform carry can move after the last telemetry sample.
    # Confirm the settled body is actually near the target before interacting.
    if abs(target-state()['x'])<(68 if DEVICE=='touch' else 32):return True
    continue
   hold('d',dist>0);hold('a',dist<0)
   data=LEVELS[s['level']] if not s['hub'] else {'ground':[[0,440,2200,180]],'length':2200}
   t=data.get('tunnel',[]);inside=t and t[0]-65<x<t[0]+t[2]+40
   if inside:
    if s['active']!=2:driver.press('3')
    if s['cooldown']<=0:driver.press('j')
   gap=any(g[0]+g[2]-75<x<g[0]+g[2]-5 and g[0]+g[2]<data['length']-10 for g in data['ground'])
   if last_x is not None and abs(x-last_x)<1:stuck+=1
   else:stuck=0
   last_x=x
   now=time.monotonic()
   if DEVICE=='touch' and stuck>5 and now-trace>3:
    trace=now;print('TOUCH TRACE',{'x':x,'y':s['y'],'held':s.get('held'),'touch_ids':s.get('touch_ids'),'driver':driver.points,'phase':jump_start,'stuck':stuck},flush=True)
   if not inside and s['floor'] and (stuck>2 or gap) and jump_start is None:
    if s['active']!=0:
     if DEVICE=='gamepad':hold('d',False);hold('a',False)
     driver.press('1')
     if DEVICE=='gamepad':hold('d',dist>0);hold('a',dist<0)
    hold('Space',True);jump_start=now;second=False
   if jump_start is not None:
    age=now-jump_start
    if age>0.24 and not second and 'Space' in held:
     hold('Space',False)
     if DEVICE=='touch':page.wait_for_timeout(100) # Separate the two presses by a rendered physics tick.
    if age>0.30 and not second:
     hold('Space',True);second=True
    if age>0.7:hold('Space',False);jump_start=None
   page.wait_for_timeout(85)
  release();print('WALK FAILED',target,state(),flush=True);return False
 try:
  page.goto('http://127.0.0.1:'+str(PORT));wait_js(page,'window.__planetQA?.menu === "title"',timeout=30000)
  if LANGUAGE=='en':
   driver.press('ArrowDown');driver.press('Enter');page.wait_for_timeout(160);driver.press('Enter');page.wait_for_timeout(160)
   driver.press('Escape');page.wait_for_timeout(180)
  page.screenshot(path=str(EVIDENCE/'title.png'))
  driver.press('Enter');page.wait_for_timeout(200);close_menu();page.wait_for_timeout(200)
  for index,data in enumerate(LEVELS[:TARGET_COUNT]):
   s=state()
   if s['hub']:
    close_menu();check(walk(2100),'Sanctuary traversed');driver.press('e');page.wait_for_timeout(240);close_menu()
   check(state()['level']==index,'Chapter '+data['id']+' reached')
   close_menu()
   for action in data['actions']:
    if state()['flags'].get(action['id']):continue
    deadline=time.monotonic()+13
    while not all(state()['flags'].get(k) for k in action['requires']) and time.monotonic()<deadline:page.wait_for_timeout(100)
    check(walk(action['x']-(0 if DEVICE=='touch' else 36)),'Walked to '+action['id'])
    if action['heroes']:driver.press(str(action['heroes'][0]+1));page.wait_for_timeout(180)
    driver.press('e');page.wait_for_timeout(230)
    check(state()['flags'].get(action['id']),action['id'])
    if not state()['flags'].get(action['id']):raise RuntimeError('Interaction failed '+action['id']+' '+str(state()))
    page.screenshot(path=str(EVIDENCE/(data['id']+'-dialogue.png')))
    close_menu()
    if action.get('timer'):page.wait_for_timeout(4300)
   deadline=time.monotonic()+12
   while not all(state()['flags'].get(k) for k in data['required']) and time.monotonic()<deadline:page.wait_for_timeout(100)
   check(all(state()['flags'].get(k) for k in data['required']),data['id']+' mandatory world conditions')
   check(walk(data['length']-100),'Exit physically reached '+data['id'])
   snaps.append(state());page.screenshot(path=str(EVIDENCE/(data['id']+'-exit.png')))
   driver.press('e');page.wait_for_timeout(260);close_menu()
  if TARGET_COUNT==10:
   check(state()['flags'].get('story_complete'),'Final story_complete in actual browser')
   check(state()['hub'],'Interactive epilogue in actual browser')
   page.screenshot(path=str(EVIDENCE/'epilogue.png'))
  else:check(TARGET_COUNT-1 in state()['completed'],'Playable slice completed through its real exit')
  # Close and reload the real IndexedDB-backed game; its state must survive.
  expected=state()['flags'];page.reload();wait_js(page,'window.__planetQA?.menu === "title"',timeout=30000)
  check(state()['flags']==expected,'Browser reload preserves all world facts')
  check(len(state()['completed'])==TARGET_COUNT,'Browser reload preserves completed chapters')
  driver.press('Enter');page.wait_for_timeout(250);close_menu();check(state()['hub'] if TARGET_COUNT==10 else state()['level']==TARGET_COUNT,'Continue restores the expected destination')
  page.screenshot(path=str(EVIDENCE/'reloaded.png'))
 except Exception as e:
  errors.append(str(e));page.screenshot(path=str(EVIDENCE/'browser-failure.png'));print('BROWSER FAILURE',str(e),flush=True)
 finally:
  release();(ROOT/('work/browser-campaign-'+DEVICE+'-'+LANGUAGE+('-slice' if TARGET_COUNT<10 else '')+('-'+os.environ.get('STP_TEST_VIEWPORT','1152x648') if DEVICE=='touch' else '')+'.json')).write_text(json.dumps({'checks':checks,'errors':errors,'input':DEVICE,'physical_gamepad':False,'snapshots':snaps,'browser':b.version,'viewport':[width,height],'renderer':'Chromium SwiftShader WebGL2','wall_seconds':time.monotonic()-started},indent=2));b.close();server.shutdown()
print('BROWSER RESULT',len(checks),'checks;',len(errors),'errors',flush=True)
raise SystemExit(1 if errors or any(not c['pass'] for c in checks) else 0)
