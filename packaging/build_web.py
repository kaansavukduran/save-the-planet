"""Real single-threaded Godot Web build, content-addressed engine/data assets."""
from pathlib import Path
import os,subprocess,hashlib,json,shutil
from setup_godot import setup
ROOT=Path(__file__).resolve().parents[1]
os.chdir(ROOT)
for key,folder in [('XDG_DATA_HOME','data'),('XDG_CONFIG_HOME','config'),('XDG_CACHE_HOME','cache')]:
 os.environ.setdefault(key,str(ROOT/'work'/folder));Path(os.environ[key]).mkdir(parents=True,exist_ok=True)
(ROOT/'work/.gdignore').touch();(ROOT/'build').mkdir(exist_ok=True);(ROOT/'build/.gdignore').touch()
engine=setup()
def run(args):
 r=subprocess.run([engine,'--headless','--path',str(ROOT),*args],capture_output=True,text=True,timeout=180)
 (ROOT/'work'/('export.log' if '--export-release' in args else 'import.log')).write_text(r.stdout+r.stderr)
 if r.returncode or 'SCRIPT ERROR' in r.stdout+r.stderr or 'Parse Error' in r.stdout+r.stderr:raise RuntimeError(r.stdout+r.stderr)
run(['--editor','--import','--quit'])
run(['--quit-after','10'])
qa=os.environ.get('STP_WEB_QA')=='1'
out=ROOT/('build/web-qa' if qa else 'build/web');out.mkdir(parents=True,exist_ok=True)
# Preserve no stale engine or data in this generated directory.
for p in out.iterdir():
 if p.is_file():p.unlink()
run(['--export-debug' if qa else '--export-release','Web',str(out/'index.html')])
html=(out/'index.html').read_text()
if qa:html=html.replace('"args":[]','"args":["--","--qa"]')
# Same content tag for js/wasm/pck: executable name resolves to the matching WASM.
tag=hashlib.sha256((out/'index.pck').read_bytes()+(out/'index.js').read_bytes()).hexdigest()[:16]
for ext in ['js','wasm','pck']:
 old='index.'+ext;new=f'planet-{tag}.'+ext
 (out/old).rename(out/new);html=html.replace(old,new)
html=html.replace('"executable":"index"',f'"executable":"planet-{tag}"')
for p in list(out.glob('index.audio*.js')):
 new=p.name.replace('index.',f'planet-{tag}.',1);p.rename(out/new);html=html.replace(p.name,new)
html=html.replace('<title>Save the Planet</title>','<title>Save the Planet · Fragaria Interactive</title>')
# Native progress callback remains intact; error text is visible and retry is real.
html=html.replace('</body>','<noscript>Save the Planet requires JavaScript / JavaScript gerekli.</noscript></body>')
html=html.replace('</head>','''<style>body{background:#173b43!important}#status{background:#173b43!important}#status-notice{color:#f5e8bb!important}#status-splash{image-rendering:pixelated}#planet-brand{position:fixed;left:18px;bottom:8px;font:12px sans-serif;color:#b7c9af;pointer-events:none;z-index:2}</style></head>''')
html=html.replace('<body>','<body><button id="planet-retry" hidden onclick="location.reload()" style="position:fixed;bottom:40px;left:20px;z-index:99">Yeniden dene / Retry</button><a id="planet-full-page" hidden target="_blank" rel="noopener" style="position:fixed;right:10px;bottom:6px;z-index:4;color:#f5e8bb">Tam sayfa / Full page</a><div id="planet-brand">SAVE THE PLANET · FRAGARIA INTERACTIVE</div>')
html=html.replace("function displayFailureNotice(err) {", "function displayFailureNotice(err) { document.getElementById('planet-retry').hidden=false;")
# Old Canvas game's service worker must not intercept the new runtime on an existing origin.
cleanup="""<script>if('serviceWorker' in navigator){navigator.serviceWorker.getRegistrations().then(rs=>Promise.all(rs.filter(r=>r.active&&/\\/(sw|index.service.worker)\\.js$/.test(new URL(r.active.scriptURL).pathname)).map(r=>r.unregister())));}window.addEventListener('error',()=>{document.getElementById('planet-retry').hidden=false;});window.addEventListener('unhandledrejection',()=>{document.getElementById('planet-retry').hidden=false;});if(window.self!==window.top){const a=document.getElementById("planet-full-page");a.hidden=false;a.href=location.href;}</script>"""
html=html.replace('</body>',cleanup+'</body>')
(out/'index.html').write_text(html)
manifest={'game_version':'0.1.0','source_commit':subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip(),'working_tree_dirty':bool(subprocess.check_output(['git','status','--porcelain'],text=True).strip()),'content_tag':tag,'files':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in out.iterdir() if p.is_file()}}
(out/'BUILD.json').write_text(json.dumps(manifest,indent=2))
print('Real Godot Web export:',out,tag)
