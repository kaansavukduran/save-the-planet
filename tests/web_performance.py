"""Measure the same real game scene before/after a change, without mutating progress."""
from pathlib import Path
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from browser_wait import wait_js
from browser_runtime import CHROMIUM
from playwright.sync_api import sync_playwright
import os, json, statistics, time, platform

ROOT=Path(__file__).resolve().parents[1]
folder=ROOT/os.environ.get('STP_PERF_WEB','build/web-qa')
mode=os.environ.get('STP_PERF_MODE','qa')
class Quiet(SimpleHTTPRequestHandler):
    def log_message(self,*args): pass
server=ThreadingHTTPServer(('127.0.0.1',8023),partial(Quiet,directory=str(folder)))
Thread(target=server.serve_forever,daemon=True).start()
with sync_playwright() as p:
    b=p.chromium.launch(executable_path=CHROMIUM,headless=True,
        args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
    page=b.new_page(viewport={'width':1152,'height':648})
    start=time.perf_counter();page.goto('http://127.0.0.1:8023')
    if mode=='release':page.locator('#loading').wait_for(state='hidden',timeout=30000)
    else:wait_js(page,'window.__planetQA?.menu === "title"',timeout=30000)
    load_ms=(time.perf_counter()-start)*1000
    page.keyboard.press('Enter');page.wait_for_timeout(250);page.keyboard.press('Escape')
    page.wait_for_timeout(1000)
    samples=page.evaluate('''()=>new Promise(resolve=>{const a=[];let last;function tick(t){if(last)a.push(t-last);last=t;if(a.length===180)resolve(a);else requestAnimationFrame(tick);}requestAnimationFrame(tick);})''')
    result={'build_mode':mode,'build':json.loads((folder/'BUILD.json').read_text()),'environment':platform.platform(),
        'browser':b.version,'renderer':'SwiftShader WebGL2','physical_device':False,
        'viewport_css':[1152,648],'canvas_backing':page.locator('canvas').evaluate('(c)=>[c.width,c.height]'),
        'scene':'a1l1 idle at start; no other game browsers running','load_ms_local':round(load_ms,1),
        'frames':len(samples),'raf_median_ms':round(statistics.median(samples),2),
        'raf_p95_ms':round(sorted(samples)[int(.95*len(samples))-1],2),
        'godot':page.evaluate('window.__planetQA?.performance || null'),'total_browser_memory':'NOT TESTED'}
    out=ROOT/'work'/os.environ.get('STP_PERF_RESULT','v11-performance-after.json')
    out.write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));b.close()
server.shutdown()
