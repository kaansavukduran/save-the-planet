from pathlib import Path
from playwright.sync_api import sync_playwright
import ast,json,sys
R=Path('/workspace/save-the-planet');sys.path.insert(0,str(R/'tests'))
from browser_runtime import CHROMIUM
from browser_wait import wait_js
AUDIO=next(ast.literal_eval(n.value) for n in ast.parse((R/'tests/browser_dialogue_audio.py').read_text()).body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='AUDIO_PROBE' for t in n.targets))
E=R/'work/dialogue-live';E.mkdir(exist_ok=True);checks=[];errors=[];audio_samples=[];build={}
def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(checks[-1],flush=True)
def sound(page):
 values=[]
 for _ in range(10):values.append(page.evaluate('window.__dialoguePCM()'));page.wait_for_timeout(90)
 audio_samples.append(values);return max(v['rms'] for v in values)
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
 context=b.new_context(viewport={'width':2048,'height':1024});context.add_init_script(AUDIO);page=context.new_page()
 page.on('pageerror',lambda e:errors.append(str(e)))
 try:
  response=page.goto('https://save-the-planet-mauve.vercel.app/play');page.locator('#loading').wait_for(state='hidden',timeout=60000)
  build=page.evaluate('async()=>await(await fetch("/BUILD.json")).json()')
  check(response.status==200 and build['game_version']=='0.4.4' and build['source_commit']=='808f1633dadf7868bc471cceb1b31231552effa0','Public entry serves the actual 0.4.4 source without login')
  check(page.evaluate('window.__planetQA === undefined'),'Shipping build has no debug QA bridge')
  page.keyboard.press('Enter');page.wait_for_timeout(450)
  check(sound(page)>.0001,'Actual music PCM continues through the first conversation on the live site')
  page.screenshot(path=str(E/'intro-2048-1024.png'));page.keyboard.press('Enter');page.wait_for_timeout(400)
  page.keyboard.down('d');page.wait_for_timeout(1400);page.keyboard.up('d');page.keyboard.press('e')
  wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.flags["a1l1.noise_off"] === true');page.wait_for_timeout(450)
  check(sound(page)>.0001,'The next actual interaction keeps music playing after its short cue has finished')
  page.screenshot(path=str(E/'fan-dialogue.png'))
  before=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))')
  page.reload();page.locator('#loading').wait_for(state='hidden',timeout=60000)
  after=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))')
  check(before['flags']==after['flags'] and before['prefs']==after['prefs'],'Progress and audio preferences survive reload')
 except Exception as e:errors.append(str(e));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(e),flush=True)
 finally:
  (E/'results.json').write_text(json.dumps({'checks':checks,'errors':errors,'audio_samples':audio_samples,'build':build,'browser':b.version,'physical_audio_hardware':'NOT TESTED'},indent=2));b.close()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
