"""Reproduce the user's archived Canvas page, then migrate real cached clients to Godot."""
from pathlib import Path
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from threading import Thread
from playwright.sync_api import sync_playwright
from browser_runtime import CHROMIUM
from browser_wait import wait_js
import json, os

ROOT=Path(__file__).resolve().parents[1]
NEW=ROOT/os.environ.get('STP_TEST_WEB_DIR','build/web-cachefix')
OLD=ROOT/os.environ.get('STP_TEST_OLD_WEB_DIR','build/web')
E=ROOT/os.environ.get('STP_TEST_EVIDENCE','docs/evidence/legacy-upgrade')
E.mkdir(parents=True,exist_ok=True)
phase=['old-godot'];checks=[];errors=[];requests=[]
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(ROOT/'legacy' if phase[0]=='legacy' else NEW if phase[0]=='fixed' else OLD),**kw)
 def log_message(self,*args):pass
 def do_GET(self):
  # Chromium can preconnect before the simulated server upgrade. Resolve the
  # active deployment per request, rather than when the socket was accepted.
  self.directory=str(ROOT/'legacy' if phase[0]=='legacy' else NEW if phase[0]=='fixed' else OLD)
  path=self.path.split('?')[0]
  if path.endswith('sw.js'):requests.append({'path':path,'phase':phase[0],'directory':self.directory})
  if phase[0]=='broken' and path in ['/sw.js','/index.service.worker.js']:
   self.send_error(404);return
  if path=='/other/sw.js':
   self.send_response(200);self.send_header('Content-Type','application/javascript');self.end_headers();self.wfile.write(b'self.addEventListener("install",()=>self.skipWaiting());');return
  if path=='/other/':
   self.send_response(200);self.send_header('Content-Type','text/html');self.end_headers();self.wfile.write(b'<title>Unrelated application</title>');return
  if phase[0]!='legacy' and path=='/':
   self.send_response(307);self.send_header('Location','/play');self.send_header('Cache-Control','no-store');self.end_headers();return
  if path=='/play':self.path='/index.html'
  if 'If-Modified-Since' in self.headers:del self.headers['If-Modified-Since']
  super().do_GET()
 def end_headers(self):
  self.send_header('Cache-Control','public, max-age=3600' if phase[0]=='legacy' else 'no-store')
  super().end_headers()
server=ThreadingHTTPServer(('127.0.0.1',8043),Handler)
Thread(target=server.serve_forever,daemon=True).start()
def check(ok,label):
 checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 context=b.new_context(viewport={'width':390,'height':844});page=context.new_page()
 page.on('pageerror',lambda e:errors.append(str(e)) if phase[0]=='fixed' else None)
 try:
  # First create a genuine Godot save using normal movement and interaction.
  page.set_viewport_size({'width':1152,'height':648});page.goto('http://127.0.0.1:8043/play')
  page.locator('#loading').wait_for(state='hidden',timeout=60000)
  page.keyboard.press('Enter');page.wait_for_timeout(250);page.keyboard.press('Escape');page.wait_for_timeout(250)
  page.keyboard.down('d');page.wait_for_timeout(1400);page.keyboard.up('d');page.keyboard.press('e')
  wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.flags["a1l1.noise_off"] === true')
  before=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))')
  check(True,'Create actual first-goal progress without injecting game state')
  page.evaluate('''async()=>{localStorage.setItem('unrelated-app','keep');const c=await caches.open('unrelated-app-cache');await c.put('/other-marker',new Response('keep'));await navigator.serviceWorker.register('/other/sw.js',{scope:'/other/'});}''')
  other=context.new_page();other.goto('http://127.0.0.1:8043/other/');other.evaluate('window.untouched=17');page.bring_to_front()
  phase[0]='legacy';page.goto('http://127.0.0.1:8043/');page.set_viewport_size({'width':390,'height':844})
  page.evaluate('navigator.serviceWorker.register("/sw.js",{scope:"/"})')
  wait_js(page,'navigator.serviceWorker.getRegistration("/").then(r=>!!r?.active)');page.reload()
  wait_js(page,'navigator.serviceWorker.controller !== null')
  check(page.locator('#lblCodex').count()==1,'Exact archived Canvas interface from the user screenshot is cached and controlled')
  phase[0]='broken';page.reload();page.wait_for_timeout(300)
  check(page.locator('#lblCodex').count()==1,'Reproduce failure: cache-first worker still shows Canvas while server serves Godot')
  page.screenshot(path=str(E/'before-cached-canvas.png'))
  # A new entry must work even before the browser revalidates the cached worker.
  phase[0]='fixed'
  page.goto('http://127.0.0.1:8043/play')
  page.locator('#loading').wait_for(state='attached',timeout=30000)
  page.locator('#loading').wait_for(state='hidden',timeout=60000)
  check(page.url=='http://127.0.0.1:8043/play' and page.locator('#lblCodex').count()==0,'New /play entry bypasses the old cached Canvas and starts Godot')
  version=json.loads((NEW/'BUILD.json').read_text())['game_version']
  check('v'+version in page.title(),'Current version is identifiable in the browser title')
  after=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))')
  check(after['flags']==before['flags'] and after['completed']==before['completed'],'Real Godot progress survives cache retirement')
  check(page.evaluate('localStorage.getItem("unrelated-app")==="keep"'),'Unrelated local storage is preserved')
  check(page.evaluate('caches.has("save-the-planet-v1").then(x=>!x)'),'Only the archived game cache is retired')
  check(page.evaluate('caches.open("unrelated-app-cache").then(c=>c.match("/other-marker")).then(r=>r.text()).then(t=>t==="keep")'),'Unrelated cached data remains intact')
  check(page.evaluate('navigator.serviceWorker.getRegistration("/other/").then(r=>!!r?.active)'),'Unrelated worker registration remains intact')
  check(other.evaluate('window.untouched===17'),'Unrelated application window is not reloaded')
  check(page.evaluate('navigator.serviceWorker.getRegistration("/").then(r=>!r)'),'Archived root registration is gone')
  check(page.evaluate('window.__planetQA === undefined'),'Migrated release exposes no QA bridge')
  page.screenshot(path=str(E/'after-godot-portrait.png'))
  page.goto('http://127.0.0.1:8043/');page.locator('#loading').wait_for(state='hidden',timeout=60000)
  check(page.url.endswith('/play') and page.locator('#lblCodex').count()==0,'A subsequent root visit stays on the current game without a reload loop')
 except Exception as e:
  errors.append(str(e));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(e),flush=True)
 finally:
  (E/'results.json').write_text(json.dumps({'checks':checks,'errors':errors,'actual_title':page.title(),'worker_requests':requests,'before_fix_status':'FAIL: archived Canvas persists despite deployed Godot HTML and missing worker URLs','old_build':json.loads((OLD/'BUILD.json').read_text()),'new_build':json.loads((NEW/'BUILD.json').read_text()),'browser':b.version,'physical_phone':'NOT TESTED'},indent=2));b.close();server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
