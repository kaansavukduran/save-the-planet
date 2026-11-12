from pathlib import Path
import json,hashlib,zipfile,tarfile,struct
R=Path('/workspace/save-the-planet');out=R/'work/dialogue-packages';out.mkdir(exist_ok=True)
checks=[]
def check(ok,name):
 checks.append({'check':name,'status':'PASS' if ok else 'FAIL'})
 if not ok:raise AssertionError(name)
for target in ['web','linux','windows']:
 b=json.loads((R/'build'/target/'BUILD.json').read_text());check(b['game_version']=='0.4.4' and b['source_commit']=='808f1633dadf7868bc471cceb1b31231552effa0' and not b['working_tree_dirty'],target+' version/source/clean export');(out/(target+'-BUILD.json')).write_text(json.dumps(b,indent=2))
for name in ['SaveThePlanet-Web.zip','SaveThePlanet-Windows-Portable.zip']:
 with zipfile.ZipFile(R/'dist'/name) as z:check(z.testzip() is None,name+' CRC')
exe=(R/'build/linux/SaveThePlanet.x86_64').read_bytes();check(exe[:5]==b'\x7fELF\x02','Linux executable ELF64')
exe=(R/'build/windows/SaveThePlanet.exe').read_bytes();pe=struct.unpack_from('<I',exe,0x3c)[0];check(exe[:2]==b'MZ' and exe[pe:pe+6]==b'PE\0\0\x64\x86','Windows executable PE x64')
m=json.loads((R/'dist/SHA256SUMS.json').read_text());check(all(hashlib.sha256((R/'dist'/n).read_bytes()).hexdigest()==v for n,v in m.items()),'All four package SHA256 hashes')
(out/'SHA256SUMS.json').write_text(json.dumps(m,indent=2));(out/'checks.json').write_text(json.dumps(checks,indent=2));print(checks)
with tarfile.open(R/'dist/SaveThePlanet-Linux-x86_64.tar.gz') as t:t.extractall('/tmp/stp-clean-linux-dialogue-044',filter='data')
script=Path('/tmp/stp-native-window-sprites.py').read_text().replace('stp-clean-linux-sprites-043','stp-clean-linux-dialogue-044').replace('docs/evidence/sprite-fix/native-window','work/dialogue-native-window').replace('work/sprite-linux-window.json','work/dialogue-linux-window.json')
(R/'work/dialogue-native-window').mkdir(exist_ok=True);(R/'work/native_dialogue_package.py').write_text(script)
mobile=(R/'work/test_sprites_mobile.py').read_text().replace('sprite-live-mobile','dialogue-live-mobile').replace('0.4.3','0.4.4');(R/'work/test_dialogue_mobile.py').write_text(mobile)
