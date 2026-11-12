"""CDP touch plus timed DOM touch gesture fixture. Read-only layout telemetry locates controls.

No keyboard events, game calls, save writes or progress injection.
"""
from browser_wait import wait_js
import time

class TouchDriver:
    KEYS={'a':'left','d':'right','s':'down','Space':'jump','j':'ability','e':'interact'}
    def __init__(self,page):
        self.page=page
        self.cdp=page.context.new_cdp_session(page)
        self.points={}
        self.next_id=1
    def state(self):return self.page.evaluate('window.__planetQA')
    def point(self,rect):
        canvas=self.page.locator('canvas').bounding_box()
        size=self.state()['layout']['viewport']
        return {'x':canvas['x']+(rect[0]+rect[2]/2)*canvas['width']/size[0],
                'y':canvas['y']+(rect[1]+rect[3]/2)*canvas['height']/size[1]}
    def send(self,kind):
        self.cdp.send('Input.dispatchTouchEvent',{'type':kind,'touchPoints':list(self.points.values())})
    def tap(self,rect):
        started=time.monotonic();key='tap';point=self.point(rect);point['id']=self.next_id;self.next_id+=1
        self.points[key]=point;self.send('touchStart');self.page.wait_for_timeout(90)
        ended=self.points.pop(key);self.cdp.send('Input.dispatchTouchEvent',{'type':'touchEnd','touchPoints':[ended]});self.page.wait_for_timeout(320)
        if time.monotonic()-started>2:print('TOUCH TAP latency',round(time.monotonic()-started,2),rect,self.state()['menu'],flush=True)
    def down(self,key):
        if key in self.points:return
        rect=self.state()['layout']['touch_rects'][self.KEYS[key]]
        point=self.point(rect);point['id']=self.next_id;self.next_id+=1
        self.points[key]=point;self.send('touchStart')
    def up(self,key):
        if key in self.points:
            ended=self.points.pop(key)
            # CDP touchEnd names fingers to END, unlike DOM's remaining touches.
            self.cdp.send('Input.dispatchTouchEvent',{'type':'touchEnd','touchPoints':[ended]})
    def release(self):
        self.points.clear();self.send('touchEnd')
    def jump_pair(self):
        """DOM touch fixture for a timed double press, through Godot's DOM listener.

        Chromium's synchronous CDP ACKs can stretch the pair past a whole jump
        in this software GPU environment. DOM timers preserve the input timing;
        positions and world facts are never set. Physical devices are NOT TESTED.
        """
        if 'Space' in self.points:self.up('Space')
        rect=self.state()['layout']['touch_rects']['jump'];point=self.point(rect)
        point['id']=10000+self.next_id;self.next_id+=1
        return self.page.evaluate("""async ({point,base})=>{
          const canvas=document.getElementById('canvas'),wait=ms=>new Promise(r=>setTimeout(r,ms));
          const make=p=>new Touch({identifier:p.id,target:canvas,clientX:p.x,clientY:p.y,pageX:p.x,pageY:p.y,screenX:p.x,screenY:p.y});
          const held=base.map(make),finger=make(point),times=[];
          const emit=(type,pressed)=>{times.push({type,t:performance.now()});canvas.dispatchEvent(new TouchEvent(type,{bubbles:true,cancelable:true,touches:pressed?[...held,finger]:held,targetTouches:pressed?[...held,finger]:held,changedTouches:[finger]}));};
          emit('touchstart',true);await wait(400);emit('touchend',false);await wait(70);
          emit('touchstart',true);await wait(180);
          const sample=structuredClone(window.__planetQA);await wait(250);emit('touchend',false);
          return {...sample,touch_fixture_timing:times};
        }""",{'point':point,'base':list(self.points.values())})
    def press(self,key,delay=None):
        state=self.state();layout=state['layout']
        if key in ['1','2','3','4']:
            self.tap(layout['heroes'][int(key)-1]);return
        if key in ['Escape','Enter']:
            if state['menu']=='':
                self.tap(layout['pause']);wait_js(self.page,'window.__planetQA.menu === "pause"',timeout=4000);return
            buttons=layout['buttons']
            if key=='Enter':button=next((b for b in buttons if b['text']==state['focus']),buttons[0])
            else:
                button=next((b for b in buttons if any(word in b['text'] for word in ['Öğretimi geç','Skip tutorial','Geri','Back','Devam','Continue','Resume'])),buttons[0])
            self.tap(button['rect'])
            if state['menu'] not in ['dialogue','new']:wait_js(self.page,'window.__planetQA.menu !== '+repr(state['menu']),timeout=4000)
            return
        self.down(key);self.page.wait_for_timeout(delay or 100);self.up(key);self.page.wait_for_timeout(100)
