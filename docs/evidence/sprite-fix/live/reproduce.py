"""Unauthenticated public Godot Web smoke: real keyboard, no QA/progress injection."""
from pathlib import Path
from playwright.sync_api import sync_playwright
import os,sys,json
ROOT=Path('/workspace/save-the-planet');sys.path.insert(0,str(ROOT/'tests'))
from browser_runtime import CHROMIUM
from browser_wait import wait_js
URL='https://save-the-planet-mauve.vercel.app/play'
E=ROOT/'work/sprite-live';E.mkdir(parents=True,exist_ok=True)
checks=[];errors=[];build={}
def check(ok,label):
 checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 page=b.new_page(viewport={'width':1152,'height':648})
 page.on('pageerror',lambda e:errors.append(str(e)))
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None)
 try:
  response=page.goto(URL,wait_until='domcontentloaded')
  check(response.status==200 and page.url.rstrip('/')==URL,'Public canonical URL opens without Vercel login or bypass token')
  page.locator('#loading').wait_for(state='hidden',timeout=60000)
  build=page.evaluate('async()=>await(await fetch("/BUILD.json")).json()')
  check(build['game_version']=='0.4.3' and build['source_commit']=='00e1c954b5b9d847d2dd16da690f464a3bf4bfec','Public build is the approved 0.4.3 sprite fix commit')
  check(page.evaluate('window.__planetQA === undefined'),'Public release has no QA bridge')
  page.keyboard.press('Enter');page.wait_for_timeout(350);page.keyboard.press('Escape');page.wait_for_timeout(350)
  page.keyboard.down('d');page.wait_for_timeout(1400);page.keyboard.up('d');page.keyboard.press('e')
  wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.flags["a1l1.noise_off"] === true',timeout=5000)
  check(True,'Real keyboard movement and interaction complete the first objective on Vercel')
  page.keyboard.press('Escape');page.wait_for_timeout(250);page.screenshot(path=str(E/'first-goal.png'))
  before=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).flags')
  page.reload();page.locator('#loading').wait_for(state='hidden',timeout=60000)
  check(page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).flags')==before,'Live progress survives reload on the public origin')
 except Exception as e:
  errors.append(str(e));page.screenshot(path=str(E/'failure.png'))
 finally:
  (E/'results.json').write_text(json.dumps({'url':URL,'checks':checks,'errors':errors,'build':build,'browser':b.version,'physical_device':'NOT TESTED'},indent=2));b.close()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
