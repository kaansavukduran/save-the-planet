"""Real keyboard/menu/multitouch/focus checks against the debug QA Web build."""
from browser_wait import wait_js
from browser_runtime import CHROMIUM
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];E=R/'docs/evidence/v0.4/accessibility';E.mkdir(parents=True,exist_ok=True)
class Quiet(SimpleHTTPRequestHandler):
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8015),partial(Quiet,directory=str(R/'build/web-qa')));Thread(target=server.serve_forever,daemon=True).start()
checks=[];errors=[]
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 page=b.new_page(viewport={'width':1152,'height':648},has_touch=True)
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None)
 page.on('pageerror',lambda e:errors.append(str(e)))
 def s():return page.evaluate('window.__planetQA')
 def check(ok,label):checks.append({'check':label,'pass':bool(ok)});print(label,ok,flush=True)
 def prefs():return page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).prefs')
 try:
  page.goto('http://127.0.0.1:8015');wait_js(page,'window.__planetQA?.menu === "title"',timeout=30000)
  page.keyboard.press('Enter');page.wait_for_timeout(220);page.keyboard.press('Escape');page.wait_for_timeout(200)
  page.keyboard.press('q');page.wait_for_timeout(200);before=s();page.keyboard.down('d');page.keyboard.press('j');page.wait_for_timeout(400);page.keyboard.up('d')
  check(abs(s()['x']-before['x'])<0.1 and s()['menu']=='party','10 Party menu blocks background movement and ability')
  page.keyboard.press('Enter');page.wait_for_timeout(240)
  check(s()['menu']=='' and s()['vy']>=0,'10 Menu accept does not jump in the world')
  page.keyboard.press('Escape');page.wait_for_timeout(120);page.keyboard.press('ArrowDown',delay=40);page.keyboard.press('ArrowDown',delay=40);page.keyboard.press('ArrowDown',delay=40);page.keyboard.press('Enter');page.wait_for_timeout(220)
  check(s()['menu']=='settings','13 Settings reached using only keyboard')
  page.keyboard.press('Enter');page.wait_for_timeout(180)
  check(prefs()['language']=='en','14 English selected and saved')
  for _ in range(2):page.keyboard.press('ArrowDown')
  page.keyboard.press('Enter');page.wait_for_timeout(180)
  check(prefs()['large_text'],'14 Large text selected and saved')
  for _ in range(3):page.keyboard.press('ArrowDown')
  page.keyboard.press('Enter');page.wait_for_timeout(180)
  check(prefs()['reduced_effects'],'15 Reduced effects selected and saved')
  for _ in range(4):page.keyboard.press('ArrowDown')
  page.keyboard.press('Enter');page.wait_for_timeout(180)
  check(prefs()['touch'],'12 Touch layout enabled from settings')
  page.screenshot(path=str(E/'english-large-settings.png'))
  page.keyboard.press('Escape');page.wait_for_timeout(150)
  if s()['menu']=='pause':page.keyboard.press('Escape');page.wait_for_timeout(200)
  before=s();cdp=page.context.new_cdp_session(page)
  cdp.send('Input.dispatchTouchEvent',{'type':'touchStart','touchPoints':[{'x':166,'y':584,'id':1},{'x':1085,'y':584,'id':2}]})
  page.wait_for_timeout(240);after=s()
  check(after['x']>before['x']+15 and after['y']<before['y']-10,'12 Simultaneous direction + jump moves and jumps')
  cdp.send('Input.dispatchTouchEvent',{'type':'touchEnd','touchPoints':[]});page.wait_for_timeout(650)
  before=s();cdp.send('Input.dispatchTouchEvent',{'type':'touchStart','touchPoints':[{'x':166,'y':584,'id':3},{'x':985,'y':584,'id':4}]});page.wait_for_timeout(240);after=s()
  check(after['x']>before['x']+15 and after['cooldown']>0,'12 Simultaneous direction + ability works')
  cdp.send('Input.dispatchTouchEvent',{'type':'touchEnd','touchPoints':[]});page.wait_for_timeout(250)
  page.screenshot(path=str(E/'touch-controls.png'))
  page.keyboard.down('d');page.wait_for_timeout(180);page.locator('canvas').evaluate('(c)=>c.blur()');page.wait_for_timeout(180)
  check(s()['menu']=='pause','11 Window blur pauses the world')
  page.locator('canvas').focus();page.keyboard.press('Escape');page.wait_for_timeout(180);before=s()['x'];page.wait_for_timeout(300)
  check(abs(s()['x']-before)<1,'11 Focus return has no stuck held direction');page.keyboard.up('d')
  expected=prefs();page.reload();wait_js(page,'window.__planetQA?.menu === "title"',timeout=30000)
  check(prefs()==expected,'08 TR/EN and accessibility preferences survive a browser reload')
  # Phone landscape layout, no desktop scaling claim for portrait.
  page.set_viewport_size({'width':844,'height':390});page.wait_for_timeout(300);page.keyboard.press('Enter');page.wait_for_timeout(220);page.keyboard.press('Escape');page.wait_for_timeout(150)
  page.screenshot(path=str(E/'phone-landscape.png'))
 except Exception as e:
  errors.append(str(e));page.screenshot(path=str(E/'accessibility-failure.png'));print('FAIL',str(e),flush=True)
 finally:
  (R/'work/browser-accessibility.json').write_text(json.dumps({'checks':checks,'errors':errors,'browser':b.version,'viewports':[[1152,648],[844,390]],'physical_gamepad':False,'physical_phone':False},indent=2));b.close();server.shutdown()
print('ACCESSIBILITY RESULT',len(checks),'checks',errors,flush=True)
raise SystemExit(1 if errors or any(not c['pass'] for c in checks) else 0)
