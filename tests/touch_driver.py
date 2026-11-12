"""CDP touch input only. Read-only layout telemetry locates native controls.

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
