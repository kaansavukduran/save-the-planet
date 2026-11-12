"""Real browser privacy, recovery and security flows with enforced production CSP."""
from browser_wait import wait_js
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json

ROOT=Path(__file__).resolve().parents[1];E=ROOT/'docs/evidence/v0.3/quality';E.mkdir(parents=True,exist_ok=True)
class Quiet(SimpleHTTPRequestHandler):
    def log_message(self,*args):pass
    def do_GET(self):
        if self.path=='/other/sw.js':
            self.send_response(200);self.send_header('Content-Type','application/javascript');self.end_headers();self.wfile.write(b'self.addEventListener("install",()=>self.skipWaiting());')
        else:super().do_GET()
server=ThreadingHTTPServer(('127.0.0.1',8025),partial(Quiet,directory=str(ROOT/'build/web-qa')))
Thread(target=server.serve_forever,daemon=True).start()
checks=[];errors=[];csp_blocks=[];expected_csp=[False]
def check(ok,label):
    checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(label,ok,flush=True)
with sync_playwright() as p:
    browser=p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
    context=browser.new_context(viewport={'width':1152,'height':648})
    context.add_init_script('''(()=>{const write=Storage.prototype.setItem;Storage.prototype.setItem=function(key,value){if(window.__denyGameSave&&key.startsWith('fragaria.save-the-planet.'))throw new DOMException('QA denied storage','QuotaExceededError');return write.call(this,key,value);};})()''')
    page=context.new_page();page.on('pageerror',lambda e:errors.append(str(e)))
    def console(message):
        if message.type!='error':return
        target=csp_blocks if expected_csp[0] and 'Content Security Policy' in message.text else errors
        target.append(message.text);print('CONSOLE',message.text,flush=True)
    page.on('console',console)
    def state():return page.evaluate('window.__planetQA')
    def choose(fragment):
        for _ in range(32):
            if fragment.lower() in state().get('focus','').lower():
                page.keyboard.press('Enter');page.wait_for_timeout(180);return
            page.keyboard.press('ArrowDown');page.wait_for_timeout(90)
        raise AssertionError('Keyboard focus could not reach '+fragment+'; '+str(state()))
    def settings():
        if state()['menu']=='':page.keyboard.press('Escape');page.wait_for_timeout(150)
        choose('Ayarlar')
    def privacy():
        settings();choose('Yerel veriler')
        if state()['menu']!='privacy':raise AssertionError('Privacy did not open')
    try:
        page.goto('http://127.0.0.1:8025');wait_js(page,'window.__planetQA?.menu === "title"')
        check(page.evaluate('localStorage.getItem("fragaria.save-the-planet.v2")===null'),'Fresh visit stores no game progress before an explicit choice')
        policy=page.locator('meta[http-equiv="Content-Security-Policy"]').get_attribute('content')
        check("'unsafe-eval'" not in policy and "'wasm-unsafe-eval'" in policy,'Policy permits WASM without general JavaScript eval')
        expected_csp[0]=True
        page.evaluate("()=>{const s=document.createElement('script');s.textContent='window.__untrustedInlineRan=true';document.body.append(s);}")
        page.wait_for_timeout(120);expected_csp[0]=False
        check(page.evaluate('window.__untrustedInlineRan!==true'),'Untrusted inline script is actually blocked by CSP')
        page.keyboard.press('Enter');page.wait_for_timeout(220);page.keyboard.press('Escape');page.wait_for_timeout(220)
        page.keyboard.down('d');page.wait_for_timeout(1400);page.keyboard.up('d');page.keyboard.press('e')
        wait_js(page,'window.__planetQA.flags["a1l1.noise_off"] === true');page.keyboard.press('Escape');page.wait_for_timeout(160)
        page.keyboard.press('F1');page.wait_for_timeout(250)
        check(page.locator('#help').is_visible() and page.get_by_role('columnheader',name='Gamepad').is_visible(),'F1 opens a semantic controls/privacy guide')
        before=state()['x'];page.keyboard.down('d');page.wait_for_timeout(250);page.keyboard.up('d')
        check(state()['menu']=='pause' and abs(state()['x']-before)<1,'Opening web help pauses the actual game and releases held movement')
        page.set_viewport_size({'width':360,'height':640});page.screenshot(path=str(E/'help-phone-portrait.png'))
        check(page.locator('#help').evaluate('(d)=>d.scrollWidth<=d.clientWidth'),'Text guide fits a small portrait viewport without horizontal overflow')
        check(page.evaluate('document.getElementById("help-body").getBoundingClientRect().bottom<=document.getElementById("help-close").getBoundingClientRect().top'),'Portrait help footer reserves space instead of covering instructions')
        page.evaluate('document.documentElement.style.fontSize="200%"')
        check(page.evaluate('document.getElementById("help-body").getBoundingClientRect().bottom<=document.getElementById("help-close").getBoundingClientRect().top'),'200% text help footer does not overlap the scrolling body')
        page.screenshot(path=str(E/'help-200-percent.png'))
        page.locator('#help-close').click();check(not page.locator('#help').is_visible(),'Text guide close action works at 200% text enlargement')
        page.keyboard.press('F1');page.wait_for_timeout(120);page.evaluate('document.documentElement.style.fontSize=""')
        page.set_viewport_size({'width':1152,'height':648});page.locator('#help-close').click();page.wait_for_timeout(180)
        choose('Devam');page.wait_for_timeout(160)
        page.evaluate('window.__denyGameSave=true');settings();choose('Büyük metin')
        wait_js(page,'window.__planetQA.storage_error === true')
        check(state()['storage_error'],'Real storage write rejection becomes a visible native saving error')
        page.screenshot(path=str(E/'saving-error.png'))
        page.evaluate('window.__denyGameSave=false');choose('Yerel veriler');choose('Kaydı yeniden dene')
        wait_js(page,'window.__planetQA.storage_error === false');check(True,'Retry saving recovers after browser storage becomes available')
        page.evaluate('localStorage.setItem("unrelated-application","keep")')
        choose('yerel verilerini sil');wait_js(page,'window.__planetQA.menu === "erase"')
        page.keyboard.press('Enter');page.wait_for_timeout(160)
        check(state()['menu']=='privacy' and state()['flags'].get('a1l1.noise_off'),'Cancel is the initial destructive-dialog action and preserves progress')
        choose('yerel verilerini sil');page.keyboard.press('ArrowDown');page.wait_for_timeout(100);page.keyboard.press('Enter')
        wait_js(page,'window.__planetQA.menu === "title" && window.__planetQA.storage_paused')
        check(page.evaluate('localStorage.getItem("fragaria.save-the-planet.v2")===null && localStorage.getItem("fragaria.save-the-planet.v2.bak")===null'),'Confirmed deletion removes both real browser snapshots')
        check(page.evaluate('localStorage.getItem("unrelated-application")==="keep"'),'Deletion preserves data belonging to another application')
        page.reload();wait_js(page,'window.__planetQA?.menu === "title"')
        check(state()['flags']=={} and state()['completed']==[],'Immediate reload cannot resurrect deleted progress from IndexedDB')
        check(page.evaluate('localStorage.getItem("fragaria.save-the-planet.v2")===null'),'Reload and focus do not recreate a save after erasure')
        page.keyboard.press('Enter');page.wait_for_timeout(200);page.keyboard.press('Escape');page.wait_for_timeout(150)
        check(page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).game_version==="0.3.0"'),'Explicit New Journey starts a new persistent save after erasure')
        page.evaluate('''()=>{const key='fragaria.save-the-planet.v2';const d=JSON.parse(localStorage.getItem(key));d.schema_version=99;localStorage.setItem(key,JSON.stringify(d));}''')
        page.locator('canvas').evaluate('(c)=>c.blur()');page.wait_for_timeout(250)
        check(page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).schema_version===99'),'A newer save written after load survives focus-loss autosave')
        page.evaluate('navigator.serviceWorker.register("/other/sw.js",{scope:"/other/"})')
        wait_js(page,'navigator.serviceWorker.getRegistration("/other/").then(r=>!!r?.active)')
        page.reload();wait_js(page,'window.__planetQA?.menu === "title"')
        check(page.evaluate('navigator.serviceWorker.getRegistration("/other/").then(r=>!!r?.active)'),'Retiring the legacy game worker preserves an unrelated application worker')
        check(bool(csp_blocks),'The browser recorded the expected CSP rejection')
        page.screenshot(path=str(E/'privacy-final.png'))
    except Exception as e:
        errors.append(str(e));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(e),flush=True)
    finally:
        result={'checks':checks,'errors':errors,'expected_csp_blocks':csp_blocks,'browser':browser.version,'physical_device':False,'screen_reader':'NOT TESTED'}
        (ROOT/'work/browser-quality.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));browser.close();server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
