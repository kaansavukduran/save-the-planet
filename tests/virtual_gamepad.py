"""Input-only Gamepad API fixture. Never writes game progress or world state.

This exercises browser polling/mapping, not physical Xbox hardware.
"""
PAD_SCRIPT='''(()=>{
 window.__nativeGamepadAvailable=typeof navigator.getGamepads==='function';
 const pad={id:'AIONIA test standard gamepad',index:0,mapping:'standard',connected:false,
  axes:[0,0,0,0],buttons:Array.from({length:17},()=>({pressed:false,touched:false,value:0})),timestamp:0};
 window.__inputPad=pad;
 Object.defineProperty(navigator,'getGamepads',{configurable:true,value:()=>[pad.connected?pad:null]});
 window.__connectInputPad=()=>{if(pad.connected)return;pad.connected=true;const event=new Event('gamepadconnected');Object.defineProperty(event,'gamepad',{value:pad});window.dispatchEvent(event);};
})()'''

class VirtualGamepad:
    BUTTONS={'Space':0,'Enter':0,'e':1,'j':2,'q':3,'Tab':8,'ArrowDown':13,'s':13}
    def __init__(self,page):
        self.page=page
        page.add_init_script(PAD_SCRIPT)
    def connect(self):
        self.page.evaluate('window.__connectInputPad()')
    def disconnect(self):
        self.page.evaluate("()=>{const pad=window.__inputPad;pad.connected=false;const event=new Event('gamepaddisconnected');Object.defineProperty(event,'gamepad',{value:pad});window.dispatchEvent(event);}")
    def button(self,index,pressed):
        self.connect()
        self.page.evaluate('([i,p])=>{const b=window.__inputPad.buttons[i];b.pressed=p;b.touched=p;b.value=p?1:0;window.__inputPad.timestamp=performance.now();}',[index,pressed])
    def steer(self,value):
        self.connect()
        self.page.evaluate('(v)=>{window.__inputPad.axes[0]=v;window.__inputPad.timestamp=performance.now();}',value)
    def down(self,key):
        self.connect()
        if key in ['a','d']:
            self.page.evaluate('(v)=>window.__inputPad.axes[0]=v',-1 if key=='a' else 1)
        else:self.button(self.BUTTONS[key],True)
    def up(self,key):
        if key in ['a','d']:self.page.evaluate('window.__inputPad.axes[0]=0')
        else:self.button(self.BUTTONS[key],False)
    def tap(self,index):
        self.button(index,True);self.page.wait_for_timeout(180)
        self.button(index,False);self.page.wait_for_timeout(180)
    def press(self,key,delay=None):
        self.connect()
        if key in ['1','2','3','4']:
            target=int(key)-1
            for _ in range(4):
                if self.page.evaluate('window.__planetQA.active')==target:return
                self.tap(5) # Web standard RB; Godot performs the real character switch.
            return
        if key=='Escape':
            menu=self.page.evaluate('window.__planetQA.menu')
            self.tap(1 if menu and menu!='pause' else 9)
        else:self.tap(self.BUTTONS[key])
