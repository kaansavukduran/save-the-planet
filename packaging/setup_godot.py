"""Pinned official Godot 4.6.3 + matching templates, checked against vendored upstream SHA-512."""
from pathlib import Path
import hashlib,os,shutil,subprocess,urllib.request,zipfile
ROOT=Path(__file__).resolve().parents[1]
VERSION='4.6.3'
def setup():
 cache=ROOT/'.ci-godot';cache.mkdir(exist_ok=True)
 sums={p[1].lstrip('*'):p[0] for l in (ROOT/'packaging/SHA512-SUMS-4.6.3.txt').read_text().splitlines() if len(p:=l.split())==2}
 base=f'https://github.com/godotengine/godot/releases/download/{VERSION}-stable/'
 for name,folder in [(f'Godot_v{VERSION}-stable_linux.x86_64.zip','engine'),(f'Godot_v{VERSION}-stable_export_templates.tpz','templates')]:
  archive=cache/name
  if not archive.exists():
   print('Downloading',name,flush=True)
   partial=archive.with_suffix('.partial')
   with urllib.request.urlopen(base+name,timeout=60) as src,partial.open('wb') as dst:shutil.copyfileobj(src,dst)
   partial.replace(archive)
  with archive.open('rb') as f:actual=hashlib.file_digest(f,'sha512').hexdigest()
  if actual!=sums[name]:raise RuntimeError('SHA-512 mismatch: '+name)
  if not (cache/folder/'.verified').exists():
   with zipfile.ZipFile(archive) as z:z.extractall(cache/folder)
   (cache/folder/'.verified').touch()
 engine=cache/f'engine/Godot_v{VERSION}-stable_linux.x86_64';engine.chmod(0o755)
 os.environ.setdefault('XDG_DATA_HOME',str(ROOT/'work/data'))
 target=Path(os.environ['XDG_DATA_HOME'])/f'godot/export_templates/{VERSION}.stable'
 if not target.exists():
  target.parent.mkdir(parents=True,exist_ok=True);target.symlink_to(cache/'templates/templates',target_is_directory=True)
 print('Verified',subprocess.check_output([str(engine),'--version'],text=True).strip(),flush=True)
 return str(engine)
if __name__=='__main__':setup()
