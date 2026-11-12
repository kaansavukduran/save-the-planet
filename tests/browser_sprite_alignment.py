"""Real animated title and player: read-only render QA, normal controls and resizing."""
from pathlib import Path
from functools import partial
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from threading import Thread
from playwright.sync_api import sync_playwright
from browser_runtime import CHROMIUM
from browser_wait import wait_js
import json, os

ROOT=Path(__file__).resolve().parents[1]
FOLDER=ROOT/os.environ.get('STP_TEST_WEB_DIR','build/web-sprites-qa')
E=ROOT/os.environ.get('STP_TEST_EVIDENCE','docs/evidence/sprite-fix/browser')
E.mkdir(parents=True,exist_ok=True)
class Quiet(SimpleHTTPRequestHandler):
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8045),partial(Quiet,directory=str(FOLDER)))
Thread(target=server.serve_forever,daemon=True).start()
checks=[];errors=[];samples=[]
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
def foot_error(v):return abs(v['opaque_bounds'][1]+v['opaque_bounds'][3]-v['root'][1])
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 page=b.new_page(viewport={'width':1152,'height':648})
 page.on('pageerror',lambda e:errors.append(str(e)))
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None)
 def state():return page.evaluate('window.__planetQA')
 try:
  page.goto('http://127.0.0.1:8045');wait_js(page,'window.__planetQA?.title_visuals?.length === 4')
  seen=[set() for _ in range(4)];horizontal=[[] for _ in range(4)];vertical=[[] for _ in range(4)]
  for i in range(80):
   row=state();samples.append(row['title_visuals'])
   for h,v in enumerate(row['title_visuals']):
    seen[h].add(v['texture']);vertical[h].append(foot_error(v))
    horizontal[h].append(v['opaque_bounds'][0]+v['opaque_bounds'][2]/2-v['root'][0])
   if i==12:page.screenshot(path=str(E/'title-stable.png'))
   if i==38:page.screenshot(path=str(E/'title-later-cycle.png'))
   page.wait_for_timeout(70)
  for h in range(4):
   check(len(seen[h])==[7,8,7,7][h],f'Hero {h}: actual complete idle/blink cycle was observed')
   check(max(vertical[h])<.05,f'Hero {h}: rendered opacity stays on the ground through every idle frame')
   check(max(horizontal[h])-min(horizontal[h])<.05,f'Hero {h}: full idle cycle has no sideways registration jump')
  page.keyboard.press('Enter');page.wait_for_timeout(250);page.keyboard.press('Escape');wait_js(page,'window.__planetQA.menu === ""')
  before=state();page.keyboard.down('d');page.wait_for_timeout(500);page.keyboard.up('d');page.wait_for_timeout(300);right=state()
  check(right['x']>before['x']+30 and right['visual']['pose']=='idle','Normal right movement stops at a stable idle pose')
  check(foot_error(right['visual'])<.05,'Right-facing gameplay feet match the actual physical body')
  page.keyboard.down('a');page.wait_for_timeout(200);page.keyboard.up('a');page.wait_for_timeout(300);left=state()
  check(left['visual']['facing']==-1 and foot_error(left['visual'])<.05,'Reversing to face left preserves ground contact')
  stationary=[]
  for _ in range(20):stationary.append(state()['x']);page.wait_for_timeout(80)
  check(max(stationary)-min(stationary)<.1,'Releasing input does not make the physical body drift')
  page.keyboard.down('Space');page.wait_for_timeout(160);air=state();page.keyboard.up('Space')
  check(air['y']<left['y']-20 and foot_error(air['visual'])<.05,'Real jump follows the physical body without a second visual translation')
  wait_js(page,'window.__planetQA.floor === true');page.wait_for_timeout(250)
  check(foot_error(state()['visual'])<.05,'Landing restores exact ground contact')
  page.set_viewport_size({'width':390,'height':844});page.wait_for_timeout(500)
  check(state()['layout']['portrait'] and foot_error(state()['visual'])<.05,'Portrait camera resizing preserves sprite-to-body registration')
  page.screenshot(path=str(E/'portrait-ground-contact.png'))
 except Exception as error:
  errors.append(str(error));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(error),flush=True)
 finally:
  result={'checks':checks,'errors':errors,'title_samples':samples,'browser':b.version,'build':json.loads((FOLDER/'BUILD.json').read_text()),'physical_device':'NOT TESTED'}
  (E/'results.json').write_text(json.dumps(result,indent=2));b.close();server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
