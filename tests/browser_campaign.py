"""Real browser, keyboard, WebGL and Godot physics. Read-only QA telemetry; never inject progress."""
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json,time
ROOT=Path(__file__).resolve().parents[1]
LEVELS=json.loads((ROOT/'data/levels.json').read_text())
class Quiet(SimpleHTTPRequestHandler):
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8013),partial(Quiet,directory=str(ROOT/'build/web-qa')))
Thread(target=server.serve_forever,daemon=True).start()
errors=[];checks=[];snaps=[];started=time.monotonic()
with sync_playwright() as p:
 b=p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 page=b.new_page(viewport={'width':1152,'height':648});page.set_default_timeout(15000)
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None)
 page.on('pageerror',lambda e:errors.append(str(e)))
 held=set()
 def hold(key,yes):
  if yes and key not in held:page.keyboard.down(key);held.add(key)
  elif not yes and key in held:page.keyboard.up(key);held.remove(key)
 def release():
  for k in list(held):hold(k,False)
 def state():return page.evaluate('window.__planetQA')
 def check(ok,label):
  checks.append({'check':label,'pass':bool(ok)});print(label,ok,flush=True)
 def close_menu():
  s=state()
  if s['menu']!='':release();page.keyboard.press('Escape');page.wait_for_timeout(180)
 def walk(target):
  last_x=None;stuck=0;jump_start=None;second=False;deadline=time.monotonic()+48
  while time.monotonic()<deadline:
   s=state()
   if s['menu']!='':close_menu();continue
   x=s['x'];dist=target-x
   if abs(dist)<21:
    release();page.keyboard.down('s');page.wait_for_timeout(650);page.keyboard.up('s');return True
   hold('d',dist>0);hold('a',dist<0)
   data=LEVELS[s['level']] if not s['hub'] else {'ground':[[0,440,2200,180]],'length':2200}
   t=data.get('tunnel',[]);inside=t and t[0]-65<x<t[0]+t[2]+40
   if inside:
    if s['active']!=2:page.keyboard.press('3')
    if s['cooldown']<=0:page.keyboard.press('j')
   gap=any(g[0]+g[2]-75<x<g[0]+g[2]-5 and g[0]+g[2]<data['length']-10 for g in data['ground'])
   if last_x is not None and abs(x-last_x)<1:stuck+=1
   else:stuck=0
   last_x=x
   now=time.monotonic()
   if not inside and s['floor'] and (stuck>2 or gap) and jump_start is None:
    if s['active']!=0:page.keyboard.press('1')
    hold('Space',True);jump_start=now;second=False
   if jump_start is not None:
    age=now-jump_start
    if age>0.24 and not second:hold('Space',False)
    if age>0.30 and not second:
     hold('Space',True);second=True
    if age>0.7:hold('Space',False);jump_start=None
   page.wait_for_timeout(85)
  release();print('WALK FAILED',target,state(),flush=True);return False
 try:
  page.goto('http://127.0.0.1:8013');page.wait_for_function('window.__planetQA?.menu === "title"',timeout=30000)
  (ROOT/'docs/evidence').mkdir(exist_ok=True)
  page.screenshot(path=str(ROOT/'docs/evidence/title.png'))
  page.keyboard.press('Enter');page.wait_for_timeout(200);close_menu();page.wait_for_timeout(200)
  for index,data in enumerate(LEVELS):
   s=state()
   if s['hub']:
    close_menu();check(walk(2100),'Sanctuary traversed');page.keyboard.press('e');page.wait_for_timeout(240);close_menu()
   check(state()['level']==index,'Chapter '+data['id']+' reached')
   close_menu()
   for action in data['actions']:
    if state()['flags'].get(action['id']):continue
    deadline=time.monotonic()+13
    while not all(state()['flags'].get(k) for k in action['requires']) and time.monotonic()<deadline:page.wait_for_timeout(100)
    check(walk(action['x']-36),'Walked to '+action['id'])
    if action['heroes']:page.keyboard.press(str(action['heroes'][0]+1));page.wait_for_timeout(180)
    page.keyboard.press('e');page.wait_for_timeout(230)
    check(state()['flags'].get(action['id']),action['id'])
    if not state()['flags'].get(action['id']):raise RuntimeError('Interaction failed '+action['id']+' '+str(state()))
    page.screenshot(path=str(ROOT/'docs/evidence'/(data['id']+'-dialogue.png')))
    close_menu()
    if action.get('timer'):page.wait_for_timeout(4300)
   deadline=time.monotonic()+12
   while not all(state()['flags'].get(k) for k in data['required']) and time.monotonic()<deadline:page.wait_for_timeout(100)
   check(all(state()['flags'].get(k) for k in data['required']),data['id']+' mandatory world conditions')
   check(walk(data['length']-100),'Exit physically reached '+data['id'])
   snaps.append(state());page.screenshot(path=str(ROOT/'docs/evidence'/(data['id']+'-exit.png')))
   page.keyboard.press('e');page.wait_for_timeout(260);close_menu()
  check(state()['flags'].get('story_complete'),'Final story_complete in actual browser')
  check(state()['hub'],'Interactive epilogue in actual browser')
  page.screenshot(path=str(ROOT/'docs/evidence/epilogue.png'))
  # Close and reload the real IndexedDB-backed game; its state must survive.
  expected=state()['flags'];page.reload();page.wait_for_function('window.__planetQA?.menu === "title"',timeout=30000)
  check(state()['flags']==expected,'Browser reload preserves all world facts')
  check(len(state()['completed'])==10,'Browser reload preserves ten completed chapters')
  page.keyboard.press('Enter');page.wait_for_timeout(250);close_menu();check(state()['hub'],'Continue after ending returns to sanctuary')
  page.screenshot(path=str(ROOT/'docs/evidence/reloaded.png'))
 except Exception as e:
  errors.append(str(e));page.screenshot(path=str(ROOT/'docs/evidence/browser-failure.png'));print('BROWSER FAILURE',str(e),flush=True)
 finally:
  release();(ROOT/'work/browser-campaign.json').write_text(json.dumps({'checks':checks,'errors':errors,'snapshots':snaps,'browser':b.version,'viewport':[1152,648],'renderer':'Chromium SwiftShader WebGL2','wall_seconds':time.monotonic()-started},indent=2));b.close();server.shutdown()
print('BROWSER RESULT',len(checks),'checks;',len(errors),'errors',flush=True)
raise SystemExit(1 if errors or any(not c['pass'] for c in checks) else 0)
