"""AIONIA v1.4: real engine, responsive menus, theme/fonts, rotation and truthful loader."""
from browser_wait import wait_js
from browser_runtime import CHROMIUM
from touch_driver import TouchDriver
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json,re,os
R=Path(__file__).resolve().parents[1];E=R/'docs/evidence/v0.4/v14';E.mkdir(parents=True,exist_ok=True)
class Quiet(SimpleHTTPRequestHandler):
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8032),partial(Quiet,directory=str(R/os.environ.get('STP_TEST_WEB_DIR','build/web-qa'))));Thread(target=server.serve_forever,daemon=True).start()
checks=[];errors=[];snapshots=[]
def check(ok,label):
 checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(label,ok,flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 page=b.new_page(viewport={'width':360,'height':640},has_touch=True,color_scheme='light');touch=TouchDriver(page)
 page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None);page.on('pageerror',lambda e:errors.append(str(e)))
 page.add_init_script('''addEventListener('DOMContentLoaded',()=>{window.__downloadSamples=[];const p=document.getElementById('progress');new MutationObserver(()=>{if(p.hasAttribute('value'))window.__downloadSamples.push({current:p.value,total:p.max,percent:document.getElementById('percent').textContent});}).observe(p,{attributes:true});});''')
 def state():return page.evaluate('window.__planetQA')
 def choose(label):
  for _ in range(60):
   if label.lower() in state().get('focus','').lower():page.keyboard.press('Enter');page.wait_for_timeout(230);return
   page.keyboard.press('ArrowDown');page.wait_for_timeout(220)
  raise AssertionError('Focus did not reach '+label)
 def prefs():return page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).prefs')
 def modal_fits():
  layout=state()['layout'];x,y,w,h=layout['modal'];vw,vh=layout['viewport']
  return x>=0 and y>=0 and x+w<=vw+1 and y+h<=vh+1
 try:
  page.goto('http://127.0.0.1:8032',wait_until='domcontentloaded');page.screenshot(path=str(E/'loading-portrait.png'))
  wait_js(page,'window.__planetQA?.menu === "title"');page.wait_for_timeout(200)
  check(state()['prefs']['theme']=='dark' and not state()['prefs']['light'],'First launch stays dark even with a light OS preference')
  check(state()['prefs']['font']=='system','Normal UI requests SystemFont by default')
  snapshots.append({'font_on_browser':state()['prefs']['font_resolved']})
  check(state()['layout']['portrait'] and state()['layout']['viewport'][0]==480,'Portrait uses its own 480-unit layout rather than a shrunken landscape')
  check(modal_fits(),'Portrait title panel fits the viewport')
  samples=page.evaluate('window.__downloadSamples')
  check(len(samples)>0 and all(s['total']>0 and int(s['percent'].rstrip('%'))==int(max(0,min(1,s['current']/s['total']))*100) for s in samples),'Displayed percentage follows observed real byte progress')
  check(page.locator('#segments span').count()==10 and page.locator('.brand img').evaluate('(e)=>e.complete&&e.naturalWidth>0'),'Loader has ten segments and a successfully decoded source strawberry')
  check(page.locator('#footer').inner_text()=='v'+re.search(r'config/version="([^"]+)"',(R/'project.godot').read_text())[1],'Loader shows the actual project version')
  check(page.locator('#loading').evaluate('(e)=>getComputedStyle(e).backgroundColor')=='rgb(0, 0, 0)','Branded loader background is black')
  check(page.evaluate('document.fonts.check("14px FragariaPixel")'),'Local licensed pixel font is loaded for decorative branding')
  touch.press('Enter');wait_js(page,'window.__planetQA.menu === "touch_intro"');check(True,'First-use touch teaching is shown')
  touch.press('Escape');wait_js(page,'window.__planetQA.menu === ""')
  check(prefs()['touch_intro_seen'],'Skip tutorial stores the first-use preference')
  touch.down('d');wait_js(page,'window.__planetQA.x >= 370',timeout=6000);touch.up('d');page.wait_for_timeout(250)
  layout=state()['layout'];x,y,w,h=layout['prompt_rect'];px,py=layout['player_screen']
  check(layout['prompt_visible'] and not (x<px+32 and x+w>px-32 and y<py and y+h>py-80),'Context action prompt does not cover the standing hero in portrait')
  page.screenshot(path=str(E/'portrait-context-visible-hero.png'))
  touch.press('e');wait_js(page,'window.__planetQA.flags["a1l1.noise_off"] === true')
  check(True,'Touch Use button invokes the actual fan interaction (previous failure regression)')
  while state()['menu']=='dialogue':touch.press('Escape')
  before=state();touch.down('d');touch.down('Space');page.wait_for_timeout(180);after=state()
  check(after['x']>before['x']+10 and after['y']<before['y']-10,'Portrait supports simultaneous touch movement and jump')
  touch.up('Space');page.wait_for_timeout(120)
  check('right' in state()['held'] and state()['vx']>0,'Releasing the jump finger keeps the direction finger held')
  touch.up('d');page.wait_for_timeout(900)
  touch.down('d');second=touch.jump_pair()
  snapshots.append({'paired_jump':{k:second.get(k) for k in ['x','y','vy','jump_count','held','touch_fixture_timing']}})
  check(second.get('jump_count')==2 and second['vy']<0,'A separate second touch press produces Aion’s real double jump')
  after=state()
  saved_flags=after['flags'];saved_level=after['level'];saved_x=after['x']
  page.set_viewport_size({'width':844,'height':390});page.wait_for_timeout(400);touch.release()
  after=state();check(not after['layout']['portrait'] and after['level']==saved_level and after['flags']==saved_flags and abs(after['x']-saved_x)<60,'Rotation mid-jump keeps the world and position without reloading the level')
  x=after['x'];page.wait_for_timeout(350);check(abs(state()['x']-x)<2,'Rotation releases held touch input instead of leaving movement stuck')
  for w,h in [(844,390),(390,844),(768,1024),(1024,768),(320,568)]:
   page.set_viewport_size({'width':w,'height':h});page.wait_for_timeout(300);layout=state()['layout'];vw,vh=layout['viewport'];rects=layout['touch_rects']
   check(all(r[0]>=0 and r[1]>=0 and r[0]+r[2]<=vw and r[1]+r[3]<=vh for r in rects.values()),f'{w}x{h}: every touch target stays inside the viewport')
   scale=min(w/vw,h/vh)
   check(all(min(r[2],r[3])*scale>=43.9 for r in rects.values()),f'{w}x{h}: action targets meet 44 CSS pixels')
   px,py=layout['player_screen'];check(0<=px<vw and 300<py<min(rects[a][1] for a in ['left','right','jump','ability']),f'{w}x{h}: player feet stay visible above touch controls')
   touch.press('Escape');page.wait_for_timeout(180);check(state()['menu']=='pause' and modal_fits(),f'{w}x{h}: pause panel adapts to the orientation');page.screenshot(path=str(E/f'pause-{w}-{h}.png'));touch.press('Escape')
  # Preference flow uses native keyboard focus and actual buttons, never sets game state.
  touch.press('Escape');choose('Ayarlar');choose('Tema:');check(prefs()['theme']=='light' and state()['prefs']['light'],'Light theme applies through the real native settings button')
  page.screenshot(path=str(E/'light-settings-portrait.png'))
  old_music=prefs()['music']
  for _ in range(30):
   if state().get('focus')=='Müzik':break
   page.keyboard.press('ArrowDown');page.wait_for_timeout(220)
  page.keyboard.press('ArrowRight');wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).prefs.music > '+str(old_music))
  slider=next(s for s in state()['layout']['sliders'] if s['name']=='Müzik')
  scale=page.viewport_size['height']/state()['layout']['viewport'][1]
  check(slider['rect'][3]*scale>=43.9 and abs(slider['value']-prefs()['music'])<.001,'Music slider has a 44px touch region and stores its real adjusted value')
  page.screenshot(path=str(E/'light-audio-settings.png'))
  choose('Geri');touch.press('Escape');wait_js(page,'window.__planetQA.menu === ""')
  check(state()['prefs']['light'],'Light theme also applies during actual touch gameplay')
  page.screenshot(path=str(E/'light-touch-gameplay.png'))
  touch.down('d');page.wait_for_timeout(200);page.screenshot(path=str(E/'light-touch-pressed.png'));touch.up('d')
  touch.press('Escape');choose('Ayarlar')
  choose('Tema:');check(prefs()['theme']=='system' and state()['prefs']['light'],'System theme follows a light browser preference')
  page.emulate_media(color_scheme='dark');wait_js(page,'window.__planetQA.prefs.light === false',timeout=5000)
  check(True,'System theme reacts to a changed browser preference without restarting')
  choose('Yazı tipi:');check(prefs()['font']=='bundled','Bundled accessible font can be selected')
  choose('Yazı tipi:');check(prefs()['font']=='system','System font can be restored')
  choose('Büyük metin:');check(prefs()['large_text'],'Large text works with the new theme and portrait layout')
  page.set_viewport_size({'width':844,'height':390});page.wait_for_timeout(300);check(modal_fits(),'Settings remains usable after rotation with large text')
  choose('Geri');touch.press('Escape');expected=prefs();page.reload();wait_js(page,'window.__planetQA?.menu === "title"')
  check(prefs()==expected and state()['prefs']['theme']=='system','Theme, font, tutorial and accessibility preferences survive reload')
  page.screenshot(path=str(E/'persisted-landscape.png'))
 except Exception as e:
  errors.append(str(e));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(e),flush=True)
 finally:
  result={'checks':checks,'errors':errors,'snapshots':snapshots,'browser':b.version,'touch_input':'CDP plus timed DOM TouchEvent pairs; actual Godot input and physics, no progress injection','physical_phone':'NOT TESTED','physical_tablet':'NOT TESTED','system_font_web_note':'Godot SystemFont requested; browser sandbox may resolve an engine fallback, unlike native OS font lookup.'}
  (R/'work/browser-v14.json').write_text(json.dumps(result,indent=2));b.close();server.shutdown()
print('V1.4 RESULT',len(checks),'checks',errors,flush=True)
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
