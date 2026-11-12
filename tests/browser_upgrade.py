"""Play a real prior release, then switch exports on the same origin without changing storage."""
from browser_wait import wait_js
from browser_runtime import CHROMIUM
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from threading import Thread
from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];E=R/'docs/evidence/v0.4/upgrade';E.mkdir(parents=True,exist_ok=True)
current=[R/'work/v03-reference/build/web'];checks=[];errors=[];requests=[]
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(current[0]),**kw)
 def log_message(self,*args):pass
 def do_GET(self):
  # The prior artifact was rebuilt later than the new one. SimpleHTTPServer's
  # timestamp-only 304 would reuse the wrong HTML; production revalidates ETags.
  if self.path in ['/', '/index.html'] and 'If-Modified-Since' in self.headers:del self.headers['If-Modified-Since']
  super().do_GET()
 def end_headers(self):
  if self.path in ['/', '/index.html']:self.send_header('Cache-Control','no-cache')
  super().end_headers()
server=ThreadingHTTPServer(('127.0.0.1',8035),Handler);Thread(target=server.serve_forever,daemon=True).start()
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(label,ok,flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader']);page=b.new_page(viewport={'width':1152,'height':648})
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None);page.on('pageerror',lambda e:errors.append(str(e)));page.on('request',lambda q:requests.append(q.url))
 def saved():return page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))')
 try:
  old=json.loads((current[0]/'BUILD.json').read_text());page.goto('http://127.0.0.1:8035');page.locator('#loading').wait_for(state='hidden',timeout=30000)
  page.keyboard.press('Enter');page.wait_for_timeout(300);page.keyboard.press('Escape');page.wait_for_timeout(300)
  page.keyboard.down('d');page.wait_for_timeout(1400);page.keyboard.up('d');page.keyboard.press('e')
  wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.flags["a1l1.noise_off"] === true')
  before=saved();check(before['game_version']=='0.3.0','Prior 0.3 release completes the real first goal and writes its actual save')
  page.screenshot(path=str(E/'v03-first-goal.png'));current[0]=R/'build/web';new=json.loads((current[0]/'BUILD.json').read_text());requests.clear()
  page.reload();page.locator('#loading').wait_for(state='hidden',timeout=30000);after=saved()
  check(after['flags']==before['flags'] and after['completed']==before['completed'],'0.3 → 0.4 reload preserves progress without modifying the saved data in the test')
  check(all(after['prefs'][key]==value for key,value in before['prefs'].items()),'All prior saved preferences are retained')
  check(after['prefs']['theme']=='dark' and after['prefs']['font']=='system','New appearance preferences default safely for a prior save')
  check(after['game_version']=='0.4.0' and after['schema_version']==before['schema_version'],'Compatible schema is retained and the actual game version advances')
  assets=[q.rsplit('/',1)[-1] for q in requests if q.endswith(('.js','.wasm','.pck'))]
  check(old['content_tag']!=new['content_tag'] and all(not a.startswith('planet-') or new['content_tag'] in a for a in assets),'Reload requests the new content-tagged engine and data')
  check(page.evaluate('window.__planetQA === undefined'),'Both shipping releases expose no QA state')
  page.screenshot(path=str(E/'v04-preserved-title.png'))
 except Exception as e:errors.append(str(e));page.screenshot(path=str(E/'failure.png'))
 finally:
  result={'checks':checks,'errors':errors,'old_export':locals().get('old'),'new_export':locals().get('new'),'source_note':'Prior release rebuilt from fe504a17; not claimed byte-identical to the archived Drive ZIP.'}
  (R/'work/browser-upgrade.json').write_text(json.dumps(result,indent=2));b.close();server.shutdown()
print('UPGRADE RESULT',len(checks),errors,flush=True)
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
