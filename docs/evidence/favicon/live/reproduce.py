from pathlib import Path
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from threading import Thread
import json,sys,struct,hashlib,os
from types import SimpleNamespace
R=Path('/workspace/save-the-planet');sys.path.insert(0,str(R/'tests'))
from browser_runtime import CHROMIUM
url=os.environ.get('STP_ICON_URL','http://127.0.0.1:8037');dest=R/'work'/os.environ.get('STP_ICON_EVIDENCE','favicon-local');dest.mkdir(exist_ok=True)
server=None;checks=[];errors=[];assets={}
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
if url.startswith('http://127.0.0.1'):
 class Handler(SimpleHTTPRequestHandler):
  def __init__(self,*a,**kw):super().__init__(*a,directory=str(R/'build/web'),**kw)
  def log_message(self,*a):pass
  def do_GET(self):
   if self.path=='/play':self.path='/index.html'
   super().do_GET()
 server=ThreadingHTTPServer(('127.0.0.1',8037),Handler);Thread(target=server.serve_forever,daemon=True).start()
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader']);page=b.new_page();page.on('pageerror',lambda e:errors.append(str(e)))
 try:
  response=page.goto(url+'/');page.locator('#loading').wait_for(state='hidden',timeout=60000)
  check(response.status==200,'Normal game entry still starts the Godot title screen')
  links=page.evaluate('''html=>[...new DOMParser().parseFromString(html,"text/html").querySelectorAll('link[rel=icon]')].map(i=>({href:i.getAttribute("href"),type:i.type}))''',response.text())
  check({x['href'].split('/')[-1] for x in links}=={'favicon.ico','favicon.png','favicon.svg'},'HTML explicitly exposes standard ICO, PNG and SVG icons')
  for name in ['favicon.ico','favicon.png','favicon.svg','index.icon.png']:
   fetched=page.evaluate('''async path=>{const r=await fetch(path);return {status:r.status,headers:Object.fromEntries(r.headers),bytes:Array.from(new Uint8Array(await r.arrayBuffer()))};}''','/'+name);r=SimpleNamespace(status=fetched['status'],headers=fetched['headers']);data=bytes(fetched['bytes']);assets[name]={'status':r.status,'type':r.headers.get('content-type'),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data),'cache_control':r.headers.get('cache-control')}
   check(r.status==200 and ('image/' in r.headers.get('content-type','') or (name.endswith('.ico') and r.headers.get('content-type','')=='application/octet-stream')),name+' is served as an actual image, not a missing route or HTML')
   (dest/name).write_bytes(data)
  png=(dest/'favicon.png').read_bytes();ico=(dest/'favicon.ico').read_bytes()
  check(png==(dest/'index.icon.png').read_bytes() and ico[:6]==b'\0\0\1\0\1\0' and ico[22:]==png,'ICO and PNG preserve the current Godot project icon pixels')
  check((dest/'favicon.svg').read_bytes()==(R/'assets/icon.svg').read_bytes(),'Vector icon is the unchanged existing planet artwork')
  decoded=page.evaluate('''async()=>{const result=[];for(const path of ['/favicon.ico','/favicon.png','/favicon.svg']){const im=new Image();im.src=path;try{await im.decode();result.push({path,width:im.naturalWidth,height:im.naturalHeight});}catch{result.push({path,error:true});}}return result;}''')
  check(all(x.get('width')==128 and x.get('height')==128 for x in decoded),'Chromium successfully decodes all three icons at 128 x 128')
  page.keyboard.press('Enter');page.wait_for_timeout(300);page.keyboard.press('Enter');page.wait_for_timeout(300)
  check(page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.game_version === "0.4.4"'),'New journey still creates the current save through the normal entry')
  page.screenshot(path=str(dest/'game.png'))
  (dest/'BUILD.json').write_text(json.dumps(page.evaluate('async()=>await(await fetch("/BUILD.json")).json()'),indent=2))
 except Exception as e:errors.append(str(e));print('FAIL',e,flush=True)
 finally:
  (dest/'results.json').write_text(json.dumps({'url':url,'checks':checks,'assets':assets,'errors':errors,'browser':b.version,'dashboard_card':'NOT TESTED'},indent=2));b.close()
if server:server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
