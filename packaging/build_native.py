"""Export and archive real Windows/Linux games; installer uses NSIS when available."""
from pathlib import Path
import hashlib,json,os,shutil,subprocess,tarfile,zipfile,re
from setup_godot import setup
ROOT=Path(__file__).resolve().parents[1];os.chdir(ROOT)
for k,n in [('XDG_DATA_HOME','data'),('XDG_CONFIG_HOME','config'),('XDG_CACHE_HOME','cache')]:os.environ.setdefault(k,str(ROOT/'work'/n));Path(os.environ[k]).mkdir(parents=True,exist_ok=True)
engine=setup();(ROOT/'dist').mkdir(exist_ok=True)
version=re.search(r'^config/version="([^"]+)"$',(ROOT/'project.godot').read_text(),re.M).group(1)
source=subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip()
for target,folder,exe in [('Linux','linux','SaveThePlanet.x86_64'),('Windows','windows','SaveThePlanet.exe')]:
 out=ROOT/'build'/folder;out.mkdir(parents=True,exist_ok=True)
 r=subprocess.run([engine,'--headless','--path',str(ROOT),'--export-release',target],capture_output=True,text=True,timeout=180)
 (ROOT/'work'/f'export-{folder}.log').write_text(r.stdout+r.stderr)
 if r.returncode or 'SCRIPT ERROR' in r.stdout+r.stderr:raise RuntimeError(r.stdout+r.stderr)
 p=out/exe
 if not p.is_file() or p.stat().st_size<1000000:raise RuntimeError('Export missing: '+str(p))
 if target=='Linux':p.chmod(0o755)
 meta={'game_version':version,'engine':'4.6.3.stable.official.7d41c59c4','source_commit':source,'target':target,'executable_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'working_tree_dirty':bool(subprocess.check_output(['git','status','--porcelain'],text=True).strip())}
 (out/'BUILD.json').write_text(json.dumps(meta,indent=2))
 for name in ['LICENSE','THIRD_PARTY_NOTICES.md']:shutil.copy2(ROOT/name,out/name)
 shutil.copy2(ROOT/'assets/fonts/LICENSE.txt',out/'FONT-LICENSE.txt')
 shutil.copy2(ROOT/'assets/fonts/PressStart2P-LICENSE.txt',out/'PressStart2P-LICENSE.txt')
 (out/'README.txt').write_text('Save the Planet '+version+' / Fragaria Interactive\nRun '+exe+'\nA/D arrows move; Space jump; J ability; E interact; 1-4 heroes; Q party; Esc pause; Tab journal; S down through platform.\nSource: https://github.com/kaansavukduran/save-the-planet\nSaves: Godot user data, local device only.\n')
 if target=='Windows':
  with zipfile.ZipFile(ROOT/'dist/SaveThePlanet-Windows-Portable.zip','w',zipfile.ZIP_DEFLATED) as z:
   for p in out.iterdir():
    if p.is_file() and not p.name.endswith('.console.exe'):z.write(p,'SaveThePlanet/'+p.name)
 else:
  with tarfile.open(ROOT/'dist/SaveThePlanet-Linux-x86_64.tar.gz','w:gz') as z:
   for p in out.iterdir():z.add(p,arcname='SaveThePlanet/'+p.name)
compiler=shutil.which('makensis')
if not compiler:
 local=ROOT/'work/nsis/usr/bin/makensis'
 if local.is_file():compiler=str(local);os.environ['NSISDIR']=str(ROOT/'work/nsis/usr/share/nsis')
if compiler:
 # Debian splits compiler plugins into lib while common data lives in share.
 local_lib=ROOT/'work/nsis/usr/lib/nsis'
 common=ROOT/'work/nsis/usr/share/nsis'
 if local_lib.is_dir():
  for folder in local_lib.iterdir():
   target=common/folder.name
   if folder.is_dir():shutil.copytree(folder,target,dirs_exist_ok=True)
 subprocess.run([compiler,'-DVERSION='+version,str(ROOT/'packaging/installer.nsi')],check=True,cwd=ROOT/'packaging')
else:print('BLOCKED Windows installer: NSIS missing')
with zipfile.ZipFile(ROOT/'dist/SaveThePlanet-Web.zip','w',zipfile.ZIP_DEFLATED) as z:
 for p in (ROOT/'build/web').iterdir():
  if p.is_file():z.write(p,p.name)
manifest={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (ROOT/'dist').iterdir() if p.is_file() and not p.name.startswith('.') and p.name!='SHA256SUMS.json'}
(ROOT/'dist/SHA256SUMS.json').write_text(json.dumps(manifest,indent=2))
print(json.dumps(manifest,indent=2))
