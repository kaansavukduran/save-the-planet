"""Real dialogue input, native layout and PCM observed through a pass-through analyser."""
from pathlib import Path
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from threading import Thread
from playwright.sync_api import sync_playwright
from browser_runtime import CHROMIUM
from browser_wait import wait_js
from touch_driver import TouchDriver
import json,os

ROOT=Path(__file__).resolve().parents[1]
FOLDER=ROOT/os.environ.get('STP_TEST_WEB_DIR','build/web-dialogue-qa')
BASELINE=os.environ.get('STP_DIALOGUE_BASELINE')
E=ROOT/os.environ.get('STP_TEST_EVIDENCE','docs/evidence/dialogue-fix/browser')
E.mkdir(parents=True,exist_ok=True);current=[FOLDER]
AUDIO_PROBE='''(()=>{
 const nativeConnect=AudioNode.prototype.connect;window.__dialogueMeters=[];
 AudioNode.prototype.connect=function(target,...rest){
  if(target===this.context.destination){
   const meter=this.context.createAnalyser();meter.fftSize=2048;
   nativeConnect.call(this,meter,...rest);nativeConnect.call(meter,target);
   window.__dialogueMeters.push(meter);window.__dialogueAudioContext=this.context;return target;
  }
  return nativeConnect.call(this,target,...rest);
 };
 window.__dialoguePCM=()=>({state:window.__dialogueAudioContext?.state,
  rms:Math.max(0,...window.__dialogueMeters.map(m=>{const a=new Float32Array(m.fftSize);m.getFloatTimeDomainData(a);return Math.sqrt(a.reduce((s,v)=>s+v*v,0)/a.length);} ))});
})()'''
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(current[0]),**kw)
 def do_GET(self):
  self.directory=str(current[0]);super().do_GET()
 def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8047),Handler);Thread(target=server.serve_forever,daemon=True).start()
checks=[];errors=[];snapshots=[];pcm_samples=[]
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
def observe(page):
 result=[]
 for _ in range(10):result.append(page.evaluate('window.__dialoguePCM()'));page.wait_for_timeout(90)
 pcm_samples.append(result);return max(s['rms'] for s in result)
def fits(info):
 h,b,s=info['header_rect'],info['body_rect'],info['scroll_rect']
 edge=info['scrollbar_rect'][0] if info['scrollbar_visible'] else s[0]+s[2]
 return info['speaker_lines']==1 and h[1]+h[3]<=s[1]+.1 and b[1]<s[1]+s[3] and b[0]+b[2]<=edge-8
with sync_playwright() as p:
 browser=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 try:
  if BASELINE:
   current[0]=ROOT/BASELINE;context=browser.new_context(viewport={'width':1152,'height':648});context.add_init_script(AUDIO_PROBE);page=context.new_page()
   page.goto('http://127.0.0.1:8047');page.locator('#loading').wait_for(state='hidden',timeout=60000)
   page.keyboard.press('Enter');page.wait_for_timeout(500);old_peak=observe(page)
   page.screenshot(path=str(E/'before-intro.png'));page.keyboard.press('Escape');page.wait_for_timeout(400);unpaused_peak=observe(page)
   snapshots.append({'baseline_paused_pcm':old_peak,'baseline_unpaused_pcm':unpaused_peak})
   check(old_peak<.00001 and unpaused_peak>.0001,'Genuine old release reproduces silent dialogue while unpaused music is measurable')
   context.close()
  current[0]=FOLDER
  for language in ['tr','en']:
   context=browser.new_context(viewport={'width':1152,'height':648});context.add_init_script(AUDIO_PROBE);page=context.new_page()
   page.on('pageerror',lambda e:errors.append(str(e)))
   page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None)
   def state():return page.evaluate('window.__planetQA')
   def choose(label,activate=True):
    for _ in range(65):
     if label.lower() in state().get('focus','').lower():
      if activate:page.keyboard.press('Enter');page.wait_for_timeout(200)
      return
     page.keyboard.press('ArrowDown');page.wait_for_timeout(130)
    raise AssertionError('Focus did not reach '+label)
   page.goto('http://127.0.0.1:8047');wait_js(page,'window.__planetQA?.menu === "title"')
   if language=='en':choose('Ayarlar');choose('Dil:');choose('Back')
   page.keyboard.press('Enter');wait_js(page,'window.__planetQA.menu === "dialogue"');page.wait_for_timeout(400)
   info=state()['layout']['dialogue'];snapshots.append(info)
   check(fits(info) and info['portrait'],language+': actual intro has a horizontal speaker, correct portrait and visible body')
   check(not info['scrollbar_visible'],language+': short intro needs no scrollbar')
   start=state();peak=observe(page);after=state()
   check(peak>.0001 and page.evaluate('window.__dialoguePCM().state')=='running',language+': measured PCM continues during a real paused dialogue')
   check(after['audio']['can_process'] and not after['audio']['stream_paused'] and after['audio']['position']!=start['audio']['position'],language+': music playback actually advances through the conversation')
   check(abs(after['audio']['volume']-after['audio']['preference']*.65)<.005,language+': dialogue applies a gentle gain without changing the preference')
   check(abs(after['x']-start['x'])<.1 and abs(after['y']-start['y'])<.1,language+': reading keeps the world still')
   for width,height in [(2048,1024),(844,390),(390,844),(320,568)]:
    page.set_viewport_size({'width':width,'height':height});page.wait_for_timeout(350);info=state()['layout']['dialogue'];snapshots.append(info)
    check(fits(info),f'{language} {width}x{height}: header/body/gutter remain readable')
    page.screenshot(path=str(E/f'{language}-{width}-{height}.png'))
   page.set_viewport_size({'width':1152,'height':648});page.wait_for_timeout(250);page.keyboard.press('Enter');wait_js(page,'window.__planetQA.menu === ""');page.wait_for_timeout(300)
   check(abs(state()['audio']['volume']-state()['audio']['preference'])<.005,language+': closing restores normal music volume')
   page.keyboard.press('Escape');choose('Ayarlar' if language=='tr' else 'Settings');choose('Müzik' if language=='tr' else 'Music',False)
   for _ in range(22):page.keyboard.press('ArrowLeft');page.wait_for_timeout(25)
   wait_js(page,'window.__planetQA.audio.preference === 0');choose('Geri' if language=='tr' else 'Back');page.keyboard.press('Escape');wait_js(page,'window.__planetQA.menu === ""')
   page.keyboard.down('d');page.wait_for_timeout(1400);page.keyboard.up('d');page.keyboard.press('e');wait_js(page,'window.__planetQA.menu === "dialogue"');page.wait_for_timeout(400)
   check(state()['audio']['preference']==0 and observe(page)<.00001,language+': player-selected mute stays silent during the next real conversation')
   page.reload();wait_js(page,'window.__planetQA?.menu === "title"')
   check(state()['audio']['preference']==0 and state()['flags'].get('a1l1.noise_off'),language+': mute and actual progress survive reload')
   context.close()
  context=browser.new_context(viewport={'width':390,'height':844},has_touch=True);context.add_init_script(AUDIO_PROBE);page=context.new_page();touch=TouchDriver(page)
  page.goto('http://127.0.0.1:8047');wait_js(page,'window.__planetQA?.menu === "title"');touch.press('Enter');touch.press('Escape')
  touch.down('d');wait_js(page,'window.__planetQA.x > 375');touch.up('d');page.wait_for_timeout(250);touch.press('e');wait_js(page,'window.__planetQA.menu === "dialogue"');page.wait_for_timeout(400)
  check(fits(page.evaluate('window.__planetQA.layout.dialogue')) and observe(page)>.0001,'Actual phone-layout touch interaction opens readable dialogue with continuing music')
  page.screenshot(path=str(E/'touch-dialogue.png'));touch.press('Enter');wait_js(page,'window.__planetQA.menu === ""');check(True,'Touch Continue closes the real dialogue')
  context.close()
 except Exception as error:
  errors.append(str(error));print('FAIL',str(error),flush=True)
  try:page.screenshot(path=str(E/'failure.png'))
  except Exception:pass
 finally:
  (E/'results.json').write_text(json.dumps({'checks':checks,'errors':errors,'snapshots':snapshots,'pcm_samples':pcm_samples,'browser':browser.version,'physical_audio_hardware':'NOT TESTED','note':'Pass-through WebAudio analyser measures actual PCM; no world facts or progress injected.'},indent=2));browser.close();server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
