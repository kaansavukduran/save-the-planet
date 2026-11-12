from pathlib import Path
from playwright.sync_api import sync_playwright
from PIL import Image
import json,sys,io,math
R=Path('/workspace/save-the-planet');sys.path.insert(0,str(R/'tests'));from browser_runtime import CHROMIUM
E=R/'work/sprite-user-resolution';E.mkdir(exist_ok=True)
width,height=2048,1024;scale=height/540;view_width=width/scale;floor=440*scale;samples=[]
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader']);page=b.new_page(viewport={'width':width,'height':height})
 page.goto('https://save-the-planet-mauve.vercel.app/play');page.locator('#loading').wait_for(state='hidden',timeout=60000)
 for i in range(16):
  shot=page.screenshot();im=Image.open(io.BytesIO(shot)).convert('RGB');counts=[]
  for hero in [0,3]:
   root=(view_width-415+hero*95)*scale;count=0
   for y in range(math.ceil(floor)+2,math.ceil(floor)+34):
    for x in range(int(root-50*scale),int(root+50*scale)):
     r,g,bl=im.getpixel((x,y));count+=(r>g+25 and bl>g+10) if hero==0 else (r>g+35 and g>bl+20)
   counts.append(count)
  samples.append(counts)
  if i in [0,8]:(E/f'title-{i}.png').write_bytes(shot)
  page.wait_for_timeout(80)
 title=page.title();b.close()
result={'viewport_css':[width,height],'title':title,'floor_y':floor,'samples_aion_owl':samples,'maximum_pixels_below_ground':max(max(row) for row in samples),'status':'PASS' if all(row==[0,0] for row in samples) and 'v0.4.3' in title else 'FAIL'};(E/'results.json').write_text(json.dumps(result,indent=2));print(json.dumps(result));raise SystemExit(0 if result['status']=='PASS' else 1)
