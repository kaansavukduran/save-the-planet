import os,subprocess,time,json
from pathlib import Path
from PIL import ImageGrab
R=Path('/workspace/save-the-planet');tools=R/'work/x11/root/usr'
env=dict(os.environ,DISPLAY=':104',LD_LIBRARY_PATH=str(tools/'lib/x86_64-linux-gnu'),XDG_DATA_HOME='/tmp/stp-clean-linux-dialogue-044/data',XDG_CONFIG_HOME='/tmp/stp-clean-linux-dialogue-044/config',XDG_CACHE_HOME='/tmp/stp-clean-linux-dialogue-044/cache')
xlog=open('/tmp/stp-xvfb.log','w');glog=open('/tmp/stp-native-window.log','w')
xvfb=subprocess.Popen([str(tools/'bin/Xvfb'),':104','-screen','0','1400x1100x24','-nolisten','tcp','-ac'],env=env,stdout=xlog,stderr=xlog)
game=None
try:
 time.sleep(.5)
 game=subprocess.Popen(['/tmp/stp-clean-linux-dialogue-044/SaveThePlanet/SaveThePlanet.x86_64','--display-driver','x11','--rendering-method','gl_compatibility','--audio-driver','Dummy'],env=env,stdout=glog,stderr=glog)
 time.sleep(2)
 def xdo(*args):return subprocess.check_output([str(tools/'bin/xdotool'),*args],env=env,text=True).strip()
 win=xdo('search','--name','Save the Planet').splitlines()[0];xdo('windowfocus',win)
 ImageGrab.grab(xdisplay=':104').save(R/'work/dialogue-native-window/linux-native-title.png')
 xdo('key','Return');time.sleep(.2);xdo('key','Escape');time.sleep(.2)
 xdo('keydown','d');time.sleep(.9);xdo('keyup','d');xdo('keydown','space');time.sleep(.18)
 ImageGrab.grab(xdisplay=':104').save(R/'work/dialogue-native-window/linux-native-gameplay.png');xdo('keyup','space')
 xdo('key','Escape');time.sleep(.15);ImageGrab.grab(xdisplay=':104').save(R/'work/dialogue-native-window/linux-native-pause.png')
 xdo('windowsize',win,'390','844');time.sleep(.7)
 ImageGrab.grab(xdisplay=':104').save(R/'work/dialogue-native-window/linux-native-portrait-pause.png')
 xdo('windowsize',win,'1152','648');time.sleep(.4)
 (R/'work/dialogue-linux-window.json').write_text(json.dumps({'opened':game.poll() is None,'display':'Xvfb 1400x1100x24','window':win,'actions':['Return new game','Escape skip dialogue','D movement','Space jump','Esc pause'],'physical_device':False},indent=2))
 print('LINUX NATIVE WINDOW TEST completed, process live:',game.poll() is None)
finally:
 if game:game.terminate();game.wait(timeout=10)
 xvfb.terminate();xvfb.wait(timeout=5)
