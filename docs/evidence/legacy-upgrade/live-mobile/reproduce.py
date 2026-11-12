from pathlib import Path
from playwright.sync_api import sync_playwright
import json,sys
R=Path('/workspace/save-the-planet');sys.path.insert(0,str(R/'tests'))
from browser_runtime import CHROMIUM
from browser_wait import wait_js
E=R/'docs/evidence/legacy-upgrade/live-mobile';E.mkdir(exist_ok=True,parents=True)
checks=[];errors=[]
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 page=b.new_page(viewport={'width':390,'height':844},has_touch=True)
 page.on('pageerror',lambda e:errors.append(str(e)))
 try:
  page.goto('https://save-the-planet-mauve.vercel.app/play');page.locator('#loading').wait_for(state='hidden',timeout=60000)
  check(page.locator('#lblCodex').count()==0 and 'v0.4.2' in page.title(),'Live portrait opens the current game rather than the archived Canvas')
  page.screenshot(path=str(E/'title.png'));page.touchscreen.tap(180,289)
  wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.game_version === "0.4.2"')
  check(True,'Actual touch on New journey starts the current game')
  page.keyboard.press('Escape');page.wait_for_timeout(400)
  cdp=page.context.new_cdp_session(page);point={'x':107.25,'y':801.7,'id':1}
  cdp.send('Input.dispatchTouchEvent',{'type':'touchStart','touchPoints':[point]});page.wait_for_timeout(1400);cdp.send('Input.dispatchTouchEvent',{'type':'touchEnd','touchPoints':[point]})
  page.touchscreen.tap(346.1,736.7)
  wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.flags["a1l1.noise_off"] === true',timeout=6000)
  check(True,'Real touch D-pad and Use complete the first fan objective on the public mobile layout')
  page.screenshot(path=str(E/'touch-first-goal.png'))
  before=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).flags')
  page.set_viewport_size({'width':844,'height':390});page.wait_for_timeout(400);page.reload();page.locator('#loading').wait_for(state='hidden',timeout=60000)
  check(page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).flags')==before,'Rotation and reload retain actual touch progress')
 except Exception as e:errors.append(str(e));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(e),flush=True)
 finally:
  (E/'results.json').write_text(json.dumps({'checks':checks,'errors':errors,'browser':b.version,'physical_phone':'NOT TESTED','input':'New journey by touch; tutorial skipped with Escape; gameplay CDP touch; read-only save verification, no progress injection'},indent=2));b.close()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
