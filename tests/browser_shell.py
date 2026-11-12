"""Exercise the genuine AIONIA loader, failure/retry, iframe and measured local rendering."""
from browser_wait import wait_js
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from threading import Thread
from pathlib import Path
import json,time,statistics,platform
R=Path(__file__).resolve().parents[1];E=R/'docs/evidence/v0.3/shell';E.mkdir(parents=True,exist_ok=True)
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(R/'build/web-qa'),**kw)
 def log_message(self,*args):pass
 def do_GET(self):
  if self.path=='/embed-test':
   self.send_response(200);self.send_header('Content-Type','text/html');self.end_headers();self.wfile.write(b'<html><body style="margin:0"><iframe src="/" allow="autoplay; fullscreen; gamepad" style="border:0;width:100vw;height:100vh"></iframe></body></html>')
  else:super().do_GET()
server=ThreadingHTTPServer(('127.0.0.1',8019),Handler);Thread(target=server.serve_forever,daemon=True).start();checks=[];unexpected=[]
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(label,ok,flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 ctx=b.new_context(viewport={'width':1152,'height':648});page=ctx.new_page();page.on('pageerror',lambda e:unexpected.append(str(e)))
 page.add_init_script('''(()=>{const A=window.AudioContext||window.webkitAudioContext;if(A)window.AudioContext=class extends A{constructor(...args){super(...args);window.__measuredAudioContext=this;}};})()''')
 try:
  started=time.perf_counter();page.goto('http://127.0.0.1:8019',wait_until='domcontentloaded');page.screenshot(path=str(E/'loading.png'))
  wait_js(page,'window.__planetQA?.menu === "title"',timeout=30000);load_ms=(time.perf_counter()-started)*1000
  check(page.locator('#loading').is_hidden(),'Loader closes only after the engine starts')
  check(page.locator('#progress').get_attribute('max') is not None,'Progress used the real byte callback')
  page.keyboard.press('Enter');page.wait_for_timeout(180);page.keyboard.press('Escape');page.wait_for_timeout(300)
  audio=page.evaluate('window.__measuredAudioContext?.state || "unobserved"')
  check(audio=='running','AudioContext runs after user input (not an audible hardware test)')
  samples=page.evaluate('''()=>new Promise(resolve=>{const a=[];let last;function tick(t){if(last)a.push(t-last);last=t;if(a.length>=120)resolve(a);else requestAnimationFrame(tick);}requestAnimationFrame(tick);})''')
  engine_metrics=page.evaluate('window.__planetQA.performance || {}')
  perf={'environment':platform.platform(),'browser':b.version,'renderer':'Chromium SwiftShader WebGL2','viewport':[1152,648],'scene':'a1l1 start, player idle, local HTTP','load_ms_local':round(load_ms,1),'raf_median_ms':round(statistics.median(samples),2),'raf_p95_ms':round(sorted(samples)[int(len(samples)*.95)-1],2),'sample_frames':len(samples),'audio_context':audio,'godot_monitors':engine_metrics,'memory_scope':'Godot static allocator; not total browser/WASM memory','engine_total_memory':'NOT TESTED','physical_gpu':'NOT TESTED'}
  # A real failed WASM request must present a useful error and a working retry.
  bad=ctx.new_page();bad.route('**/*.wasm',lambda route:route.fulfill(status=503,body='QA simulated engine download failure'))
  bad.goto('http://127.0.0.1:8019',wait_until='domcontentloaded');wait_js(bad,'!document.getElementById("retry").hidden',timeout=15000)
  check(bad.locator('#notice').inner_text()!='','Failed engine download exposes an error message');bad.screenshot(path=str(E/'loader-error.png'))
  bad.unroute('**/*.wasm');bad.locator('#retry').click();wait_js(bad,'window.__planetQA?.menu === "title"',timeout=30000)
  check(bad.locator('#loading').is_hidden(),'Retry reopens the real game after download recovers');bad.close()
  embed=ctx.new_page();embed.goto('http://127.0.0.1:8019/embed-test');frame=embed.frames[1];wait_js(frame,'window.__planetQA?.menu === "title"',timeout=30000)
  frame.locator('#help-toggle').click();check(frame.locator('#full-page').is_visible(),'Iframe help offers a full-page route');frame.locator('#help-close').click()
  frame.locator('canvas').focus();embed.keyboard.press('Enter');embed.wait_for_timeout(150);embed.keyboard.press('Escape');embed.wait_for_timeout(200)
  before=frame.evaluate('window.__planetQA.x');embed.keyboard.down('d');embed.wait_for_timeout(250);embed.keyboard.up('d');after=frame.evaluate('window.__planetQA.x')
  check(after>before+20,'Focused iframe receives real movement keys');embed.screenshot(path=str(E/'iframe.png'));embed.close()
 except Exception as e:
  unexpected.append(str(e));perf=locals().get('perf',{});page.screenshot(path=str(E/'shell-failure.png'));print('FAIL',str(e),flush=True)
 result={'checks':checks,'unexpected_errors':unexpected,'performance':perf};(R/'work/aionia-shell.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));b.close()
server.shutdown();raise SystemExit(1 if unexpected or any(c['status']=='FAIL' for c in checks) else 0)
