"""Keyboard-free native menus, remapping and hotplug through the browser Gamepad API fixture."""
from browser_wait import wait_js
from browser_runtime import CHROMIUM
from virtual_gamepad import VirtualGamepad
from playwright.sync_api import sync_playwright
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1];E=ROOT/'docs/evidence/v0.4/gamepad-menus';E.mkdir(parents=True,exist_ok=True)
class Quiet(SimpleHTTPRequestHandler):
    def log_message(self,*args):pass
server=ThreadingHTTPServer(('127.0.0.1',8027),partial(Quiet,directory=str(ROOT/'build/web-qa')))
Thread(target=server.serve_forever,daemon=True).start();checks=[];errors=[]
with sync_playwright() as p:
    browser=p.chromium.launch(executable_path=CHROMIUM,headless=True,args=['--no-sandbox','--enable-unsafe-swiftshader','--use-angle=swiftshader'])
    page=browser.new_page(viewport={'width':1152,'height':648});pad=VirtualGamepad(page)
    page.on('console',lambda m:errors.append(m.text) if m.type=='error' else None);page.on('pageerror',lambda e:errors.append(str(e)))
    def state():return page.evaluate('window.__planetQA')
    def check(ok,label):checks.append({'check':label,'status':'PASS' if ok else 'FAIL'});print(label,ok,flush=True)
    def choose(label):
        for _ in range(32):
            if label.lower() in state().get('focus','').lower():pad.press('Enter');page.wait_for_timeout(140);return
            pad.press('ArrowDown')
        raise AssertionError('Gamepad focus could not find '+label)
    try:
        page.goto('http://127.0.0.1:8027');wait_js(page,'window.__planetQA?.menu === "title"')
        check(page.evaluate('window.__nativeGamepadAvailable && isSecureContext'),'Chromium exposes the native Gamepad API in a secure context')
        choose('Ayarlar');wait_js(page,'window.__planetQA.menu === "settings"');pad.tap(9)
        check(state()['menu']=='title','Start from title settings does not launch an unstarted game')
        pad.press('Enter');page.wait_for_timeout(180);pad.press('Escape');page.wait_for_timeout(160)
        check(state()['menu']=='' and state()['input_method']=='gamepad','A starts and B dismisses dialogue without keyboard input')
        pad.tap(9);choose('Ayarlar');pad.press('Enter');page.wait_for_timeout(160)
        choose('Gamepad bindings');choose('Ability')
        pad.tap(11) # Web-standard right stick button, translated by Godot.
        choose('Ability')
        check('RS' in state()['focus'],'Gamepad remap screen displays the actual reassigned RS label')
        pad.tap(9) # Cancel capture; next Start resumes.
        pad.tap(9);page.wait_for_timeout(180)
        pad.tap(11)
        check(state()['cooldown']>0,'Reassigned RS triggers the real gameplay ability through browser polling')
        wait_js(page,'window.__planetQA.cooldown <= 0');pad.tap(2)
        check(state()['cooldown']==0,'Old X binding is removed after remapping')
        page.screenshot(path=str(E/'rebound-ability.png'))
        pad.down('d');page.wait_for_timeout(230);pad.disconnect();page.wait_for_timeout(250)
        check(state()['menu']=='pause','Gamepad API disconnect pauses the real game')
        before=state()['x'];page.wait_for_timeout(250)
        check(abs(state()['x']-before)<1,'Disconnect releases the held direction')
        pad.connect();page.wait_for_timeout(180)
        check(state()['menu']=='pause','Reconnect waits for explicit resume')
        pad.tap(9);page.wait_for_timeout(180)
        check(state()['menu']=='','Start resumes after reconnection')
        page.screenshot(path=str(E/'reconnected.png'))
        page.reload();wait_js(page,'window.__planetQA?.menu === "title"')
        pad.press('Enter');page.wait_for_timeout(180);pad.press('Escape');page.wait_for_timeout(150);pad.tap(11)
        check(state()['cooldown']>0,'Gamepad remapping survives reload and a new journey')
    except Exception as e:
        errors.append(str(e));page.screenshot(path=str(E/'failure.png'));print('FAIL',str(e),flush=True)
    finally:
        result={'checks':checks,'errors':errors,'input':'virtual browser Gamepad API','physical_gamepad':'NOT TESTED','browser':browser.version}
        (ROOT/'work/browser-gamepad-menus.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));browser.close();server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
