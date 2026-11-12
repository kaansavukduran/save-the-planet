"""Compare real shipping pixels, including a genuine pre-fix archived release."""
from pathlib import Path
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from playwright.sync_api import sync_playwright
from PIL import Image
import sys,json,io,zipfile
R=Path('/workspace/save-the-planet');sys.path.insert(0,str(R/'tests'))
from browser_runtime import CHROMIUM
folder=R/'work/sprite-baseline-web';folder.mkdir(exist_ok=True)
with zipfile.ZipFile(R/'work/release-0.4.1/SaveThePlanet-0.4.1-Web.zip') as z:z.extractall(folder)
class Quiet(SimpleHTTPRequestHandler):
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8046),partial(Quiet,directory=str(folder)));Thread(target=server.serve_forever,daemon=True).start()
E=R/'work/sprite-pixels';E.mkdir(exist_ok=True);results=[]
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 for label,url in [('before','http://127.0.0.1:8046/'),('after','https://save-the-planet-mauve.vercel.app/play')]:
  page=b.new_page(viewport={'width':1152,'height':648});page.goto(url);page.locator('#loading').wait_for(state='hidden',timeout=60000)
  samples=[];worst=-1
  for i in range(24):
   shot=page.screenshot();im=Image.open(io.BytesIO(shot)).convert('RGB');pink=orange=0
   for y in range(530,562):
    for x in range(592,714):
     r,g,bl=im.getpixel((x,y));pink+=r>g+25 and bl>g+10
    for x in range(944,1048):
     r,g,bl=im.getpixel((x,y));orange+=r>g+35 and g>bl+20
   samples.append({'aion_pixels_below_road':pink,'owl_pixels_below_road':orange})
   if pink+orange>worst:worst=pink+orange;(E/(label+'-worst.png')).write_bytes(shot)
   page.wait_for_timeout(70)
  row={'label':label,'url':url,'max_aion_pixels_below_road':max(s['aion_pixels_below_road'] for s in samples),'max_owl_pixels_below_road':max(s['owl_pixels_below_road'] for s in samples),'samples':samples};results.append(row);print(row,flush=True);page.close()
 b.close()
server.shutdown();checks=[{'check':'Archived release reproduces visible sinking','status':'PASS' if results[0]['max_aion_pixels_below_road']>0 else 'FAIL'},{'check':'Live Aion never paints below the ground over multiple blink cycles','status':'PASS' if results[1]['max_aion_pixels_below_road']==0 else 'FAIL'},{'check':'Live Owl never paints below the ground over multiple idle cycles','status':'PASS' if results[1]['max_owl_pixels_below_road']==0 else 'FAIL'}]
(E/'results.json').write_text(json.dumps({'checks':checks,'measurements':results,'note':'Actual release screenshots, no QA bridge. At 1152x648 the road is y528; sampled y530..561. Color masks select Aion pink and owl orange while excluding meadow terrain.'},indent=2));raise SystemExit(1 if any(c['status']=='FAIL' for c in checks) else 0)
