"""Smoke-test the shipping export using keyboard input and its real persisted save."""
from pathlib import Path
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from functools import partial
from threading import Thread
from browser_wait import wait_js
from playwright.sync_api import sync_playwright
import json

ROOT = Path(__file__).resolve().parents[1]
E=ROOT/'docs/evidence/v0.3/release';E.mkdir(parents=True,exist_ok=True)
class Quiet(SimpleHTTPRequestHandler):
    def log_message(self, *args): pass

server = ThreadingHTTPServer(('127.0.0.1', 8021), partial(Quiet, directory=str(ROOT/'build/web')))
Thread(target=server.serve_forever, daemon=True).start()
checks, errors = [], []
with sync_playwright() as p:
    browser = p.chromium.launch(executable_path='/usr/bin/chromium', headless=True,
        args=['--no-sandbox', '--enable-unsafe-swiftshader', '--use-angle=swiftshader'])
    page = browser.new_page(viewport={'width':1152,'height':648})
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.on('console', lambda m: errors.append(m.text) if m.type == 'error' else None)
    def check(ok, label):
        checks.append({'check': label, 'status': 'PASS' if ok else 'FAIL'})
    try:
        page.goto('http://127.0.0.1:8021')
        page.locator('#loading').wait_for(state='hidden',timeout=30000)
        check(page.evaluate('window.__planetQA === undefined'), 'Shipping build has no QA telemetry')
        page.keyboard.press('Enter'); page.wait_for_timeout(250)
        page.keyboard.press('Escape'); page.wait_for_timeout(250)
        page.keyboard.down('d'); page.wait_for_timeout(1400); page.keyboard.up('d')
        page.keyboard.press('e')
        wait_js(page,'JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2"))?.flags["a1l1.noise_off"] === true',timeout=3000)
        check(True, 'Shipping build reaches and completes its first goal using real input')
        page.keyboard.press('Escape'); page.wait_for_timeout(150)
        page.screenshot(path=str(E/'release-first-goal.png'))
        before=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).flags')
        page.reload(); page.locator('#loading').wait_for(state='hidden',timeout=30000)
        after=page.evaluate('JSON.parse(localStorage.getItem("fragaria.save-the-planet.v2")).flags')
        check(before==after, 'Shipping build preserves first-goal progress across reload')
    except Exception as e:
        errors.append(str(e))
    finally:
        result={'checks':checks,'errors':errors,'build':json.loads((ROOT/'build/web/BUILD.json').read_text())}
        (ROOT/'work/browser-release.json').write_text(json.dumps(result,indent=2))
        print(json.dumps(result,indent=2)); browser.close(); server.shutdown()
raise SystemExit(1 if errors or any(c['status']=='FAIL' for c in checks) else 0)
