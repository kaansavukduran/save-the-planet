"""Real camera/sky regression across rotation, ultrawide and tall portrait views."""
from pathlib import Path
from functools import partial
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from threading import Thread
from playwright.sync_api import sync_playwright
from browser_runtime import CHROMIUM
from browser_wait import wait_js
import base64, json, os

ROOT = Path(__file__).resolve().parents[1]
FOLDER = ROOT / os.environ.get('STP_TEST_WEB_DIR', 'build/web-qa')
EVIDENCE = ROOT / os.environ.get('STP_RENDER_EVIDENCE', 'docs/evidence/forge/render')
EVIDENCE.mkdir(parents=True, exist_ok=True)

class Quiet(SimpleHTTPRequestHandler):
    def log_message(self, *args): pass

server = ThreadingHTTPServer(('127.0.0.1', 8041), partial(Quiet, directory=str(FOLDER)))
Thread(target=server.serve_forever, daemon=True).start()
checks, errors, samples = [], [], []

def check(ok, label):
    checks.append({'check': label, 'status': 'PASS' if ok else 'FAIL'})
    print(checks[-1], flush=True)

def capture_edges(page, width, height, name):
    screenshot = page.screenshot(path=str(EVIDENCE / name))
    # Read screenshot pixels through a separate 2D canvas; no extra PNG library.
    return page.evaluate('''async ({src, points}) => {
        const image = new Image(); image.src = src; await image.decode();
        const canvas = document.createElement('canvas');
        canvas.width = image.width; canvas.height = image.height;
        const context = canvas.getContext('2d'); context.drawImage(image, 0, 0);
        return points.map(([x,y]) => Array.from(context.getImageData(x,y,1,1).data));
    }''', {'src': 'data:image/png;base64,' + base64.b64encode(screenshot).decode(),
           'points': [[width-5, 200], [3, 180]]})

with sync_playwright() as p:
    browser = p.chromium.launch(executable_path=CHROMIUM, headless=True,
        args=['--no-sandbox', '--enable-unsafe-swiftshader', '--use-angle=swiftshader'])
    page = browser.new_page(viewport={'width': 1152, 'height': 648}, has_touch=True)
    page.on('pageerror', lambda error: errors.append(str(error)))
    page.on('console', lambda msg: errors.append(msg.text) if msg.type == 'error' else None)
    try:
        page.goto('http://127.0.0.1:8041')
        wait_js(page, 'window.__planetQA?.menu === "title"')
        page.keyboard.press('Enter')
        wait_js(page, 'window.__planetQA.menu !== "title"')
        page.keyboard.press('Escape')
        wait_js(page, 'window.__planetQA.menu === ""')
        page.wait_for_timeout(500)
        before = page.evaluate('window.__planetQA')
        for width, height in [(1152,648), (1920,720), (2560,720), (390,1000), (360,640), (844,390)]:
            page.set_viewport_size({'width': width, 'height': height})
            page.wait_for_timeout(550)
            state = page.evaluate('window.__planetQA')
            pixels = capture_edges(page, width, height, f'{width}-{height}.png')
            samples.append({'viewport_css': [width,height], 'engine_viewport': state['layout']['viewport'],
                            'edge_pixels_rgba': pixels})
            check(all(pixel[:3] != [18,38,48] for pixel in pixels),
                  f'{width}x{height}: sky covers right and upper edges without clear-color gaps')
            check(state['level'] == before['level'] and state['flags'] == before['flags']
                  and abs(state['x'] - before['x']) < 2 and abs(state['y'] - before['y']) < 2,
                  f'{width}x{height}: resizing preserves actual body and progress')
            px, py = state['layout']['player_screen']
            vw, vh = state['layout']['viewport']
            check(0 <= px < vw and 0 < py < vh,
                  f'{width}x{height}: actual hero stays on screen')
        page.keyboard.press('Escape')
        wait_js(page, 'window.__planetQA.menu === "pause"')
        for width, height in [(1152,648), (2560,720), (390,1000)]:
            page.set_viewport_size({'width': width, 'height': height})
            page.wait_for_timeout(550)
            pixels = capture_edges(page, width, height, f'paused-{width}-{height}.png')
            state = page.evaluate('window.__planetQA')
            # Clear color under the 55% pause dimmer is approximately (12,25,34).
            # Allow GPU rounding, while requiring actual scenery behind the dimmer.
            check(all(sum(abs(value-clear) for value,clear in zip(pixel[:3], [12,25,34])) > 30
                      for pixel in pixels),
                  f'{width}x{height}: sky repaints during paused resizing')
            check(state['menu'] == 'pause' and abs(state['x']-before['x']) < 2
                  and state['flags'] == before['flags'],
                  f'{width}x{height}: paused resizing keeps pause and progress')
    except Exception as error:
        errors.append(str(error))
        page.screenshot(path=str(EVIDENCE / 'failure.png'))
    finally:
        result = {'checks': checks, 'errors': errors, 'samples': samples,
                  'browser': browser.version, 'renderer': 'SwiftShader WebGL2',
                  'build': json.loads((FOLDER/'BUILD.json').read_text()),
                  'physical_device': 'NOT TESTED'}
        (EVIDENCE/'results.json').write_text(json.dumps(result, indent=2))
        browser.close()
        server.shutdown()

raise SystemExit(1 if errors or any(c['status'] == 'FAIL' for c in checks) else 0)
