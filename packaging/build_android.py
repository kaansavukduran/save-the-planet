"""Release-only Android export. Never generate or replace the owner's signing identity."""
from pathlib import Path
import os,subprocess
from setup_godot import setup
ROOT=Path(__file__).resolve().parents[1]
required=['ANDROID_HOME','JAVA_HOME','GODOT_ANDROID_KEYSTORE_RELEASE_PATH','GODOT_ANDROID_KEYSTORE_RELEASE_USER','GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD']
missing=[k for k in required if not os.environ.get(k)]
if missing:raise SystemExit('BLOCKED Android release; configure securely: '+', '.join(missing))
if not Path(os.environ['GODOT_ANDROID_KEYSTORE_RELEASE_PATH']).is_file():raise SystemExit('Release keystore file unavailable; identity was not replaced.')
os.chdir(ROOT)
for k,n in [('XDG_DATA_HOME','data'),('XDG_CONFIG_HOME','config'),('XDG_CACHE_HOME','cache')]:os.environ.setdefault(k,str(ROOT/'work'/n));Path(os.environ[k]).mkdir(parents=True,exist_ok=True)
engine=setup();(ROOT/'build/android').mkdir(parents=True,exist_ok=True)
settings=Path(os.environ['XDG_CONFIG_HOME'])/'godot/editor_settings-4.6.tres'
settings.parent.mkdir(parents=True,exist_ok=True)
# Paths only. Signing credentials stay in inherited environment variables.
settings.write_text('[gd_resource type="EditorSettings" format=3]\n[resource]\nexport/android/android_sdk_path = '+repr(os.environ['ANDROID_HOME']).replace("'",'"')+'\nexport/android/java_sdk_path = '+repr(os.environ['JAVA_HOME']).replace("'",'"')+'\n')
subprocess.run([engine,'--headless','--path',str(ROOT),'--export-release','Android'],check=True)
apk=ROOT/'build/android/SaveThePlanet-Android.apk'
if not apk.is_file():raise SystemExit('Release APK not produced')
print('Release APK exported. Verify signature with apksigner and test on a physical device before distribution.')
