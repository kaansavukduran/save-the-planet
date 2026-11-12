"""Serve two genuine content-tagged Godot exports on the same origin and retain progress."""
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json
R=Path(__file__).resolve().parents[1]
current=[R/'work/previous-web'];errors=[];requests=[]
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(current[0]),**kw)
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8016),Handler);Thread(target=server.serve_forever,daemon=True).start()
with sync_playwright() as p:
 b=p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader']);page=b.new_page(viewport={'width':1152,'height':648})
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None);page.on('pageerror',lambda e:errors.append(str(e)));page.on('request',lambda q:requests.append(q.url))
 page.goto('http://127.0.0.1:8016');page.wait_for_function('window.__planetQA?.menu === "title"',timeout=30000)
 page.keyboard.press('Enter');page.wait_for_timeout(180);page.keyboard.press('Escape');page.wait_for_timeout(180);page.keyboard.down('d');page.wait_for_function('window.__planetQA.x>375');page.keyboard.up('d');page.keyboard.press('e');page.wait_for_function('window.__planetQA.flags["a1l1.noise_off"]===true')
 expected=page.evaluate('window.__planetQA.flags');old=json.loads((current[0]/'BUILD.json').read_text())['content_tag']
 current[0]=R/'build/web-qa';new=json.loads((current[0]/'BUILD.json').read_text())['content_tag'];requests.clear()
 page.reload();page.wait_for_function('window.__planetQA?.menu === "title"',timeout=30000)
 actual=page.evaluate('window.__planetQA.flags');assets=[q.rsplit('/',1)[-1] for q in requests if q.endswith(('.js','.wasm','.pck'))]
 result={'old_content_tag':old,'new_content_tag':new,'different_exports':old!=new,'progress_preserved':expected==actual,'new_engine_assets_only':all(not name.startswith('planet-') or new in name for name in assets),'assets':assets,'errors':errors}
 page.screenshot(path=str(R/'docs/evidence/web-update.png'));(R/'work/web-update-results.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));b.close()
server.shutdown()
raise SystemExit(0 if old!=new and expected==actual and result['new_engine_assets_only'] and not errors else 1)
