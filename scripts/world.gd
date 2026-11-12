class_name PlanetWorld
extends Node2D
signal animal_arrived
var spec: Dictionary = {}
var clock=0.0
var camera_x=0.0
var view_bounds=Rect2(0,0,960,540)
var draw_cpu_usec=0
var solids: Array = []
var gates: Array = []
var moving: Array = []
var actor_x=0.0
var actor_done=false
var actors: Array = []
var timer=0.0
var props: Dictionary = {}
var mechanism_times: Dictionary = {}
const PALETTES={"meadow":["95c7bd","c8dfb3","446c72","355c51","e4d5a7"],"workshop":["8daab2","d4c8a6","596a79","45505c","bc9570"],"river":["80b7cd","bce2d4","446b7d","356c65","ddce9d"],"forest":["80b0a6","bbd5aa","3d6463","284d46","bea47c"],"town":["c4b2bd","ead1af","68748b","56686f","d6b492"],"coast":["82bdce","e5dec1","557d90","426578","e6cfa3"],"finale":["768f9c","c6b8ad","4f5a70","344e58","bdac8d"]}

func _ready() -> void:
	# Resizing a paused menu must also repaint the scenery behind it.
	get_viewport().size_changed.connect(queue_redraw)

func solid(rect: Rect2,animated: bool=false) -> PhysicsBody2D:
	var b: PhysicsBody2D=AnimatableBody2D.new() if animated else StaticBody2D.new()
	var c=CollisionShape2D.new();var shape=RectangleShape2D.new();shape.size=rect.size;c.shape=shape
	if rect.size.y<=22:
		c.one_way_collision=true;c.one_way_collision_margin=5;b.collision_layer=2
	b.position=rect.get_center();add_child(b);b.add_child(c);solids.append(rect);return b

func setup(data: Dictionary) -> void:
	spec=data
	for name in ["forest-arch","pipe-arch","log","barrier","rocks","grass-left","grass-right","industrial-left","industrial-right"]:props[name]=load("res://assets/derived/prop-"+name+".png")
	for g in spec.ground:solid(Rect2(g[0],g[1],g[2],g[3]))
	for p in spec.platforms:solid(Rect2(p[0],p[1],p[2],p[3]))
	if spec.has("tunnel"):
		var t=spec.tunnel;solid(Rect2(t[0],t[1],t[2],t[3]))
	for g in spec.get("gates",[]):
		if State.flags.get(g.flag,false):continue
		var r=g.rect;gates.append({"flag":g.flag,"body":solid(Rect2(r[0],r[1],r[2],r[3]))})
	for m in spec.get("moving",[]):
		var r=Rect2(m[0],m[1],m[2],m[3]);var b=solid(r,true)
		moving.append({"body":b,"origin":r.get_center(),"size":r.size,"amplitude":Vector2(m[4],m[5])})
	if spec.has("animal"):
		var a=spec.animal
		actor_done=State.flags.get(a.arrived,false);actor_x=float(a.to if actor_done else a.from)
	for a in spec.actions:
		if a.kind=="friend":
			var v=HeroVisual.new();v.hero=int(a.unlock);v.position=Vector2(a.x+40,440);add_child(v);actors.append({"id":a.id,"visual":v})
	if spec.id=="sanctuary":
		for i in State.unlocked:
			var v=HeroVisual.new();v.hero=int(i);v.position=Vector2(690+int(i)*145,440);v.pose="idle";add_child(v);actors.append({"id":"hub.friend"+str(i),"visual":v})

func _physics_process(dt: float) -> void:
	clock+=dt
	for m in moving:
		m.body.position=m.origin+m.amplitude*sin(clock*1.15)
	for g in gates:
		if is_instance_valid(g.body) and State.flags.get(g.flag,false):g.body.queue_free()
	for a in spec.get("actions",[]):
		if State.flags.get(a.id,false):mechanism_times[a.id]=minf(1.0,float(mechanism_times.get(a.id,0.0))+dt*2.5)
		if a.has("timer") and State.flags.get(a.id,false) and not State.flags.get(a.timer_flag,false):
			timer+=dt
			if timer>=float(a.timer):State.mark(a.timer_flag)
	if spec.has("animal") and not actor_done:
		var a=spec.animal
		if State.has_all(a.requires):
			actor_x=move_toward(actor_x,float(a.to),95*dt)
			if actor_x>=float(a.to):
				actor_done=true;State.animals[a.id]={"habitat":a.habitat,"status":"safe"};State.mark(a.arrived);animal_arrived.emit()
	queue_redraw()

func wind_at(p: Vector2) -> Vector2:
	for w in spec.get("wind",[]):
		if Rect2(w[0],w[1],w[2],w[3]).has_point(p):return Vector2(0,-95)
	return Vector2.ZERO

func danger_phase() -> int:
	# Explicit warning before each active interval, then a generous safe interval.
	var phase=fmod(clock,4.5)
	return 1 if phase<0.8 else (2 if phase<2.3 else 0)

func unsafe_at(p: Vector2) -> bool:
	if State.flags.get(spec.get("hazard_disable",""),false):return false
	if danger_phase()!=2:return false
	for h in spec.hazards:
		if Rect2(h[0]-12,h[1]-8,h[2]+24,h[3]+8).has_point(p-Vector2(0,15)):return true
	return false

func _draw() -> void:
	if spec.is_empty():return
	var draw_started=Time.get_ticks_usec() if OS.is_debug_build() else 0
	# Read the rendered camera transform: portrait and ultrawide views expand the world.
	view_bounds=get_viewport().get_canvas_transform().affine_inverse()*get_viewport_rect()
	var palette=PALETTES[spec.biome];var end=float(spec.length)
	draw_backdrop(palette,end)
	if spec.has("water"):
		var w=spec.water;var polluted=not State.flags.get("a2l1.source_stopped",false) and spec.id=="a2l1"
		draw_rect(Rect2(w[0],w[1],w[2],w[3]),Color("6e637b" if polluted else "518fa4"))
		for x in range(int(w[0]),int(w[0]+w[2]),55):
			if not visible_x(x):continue
			draw_line(Vector2(x,w[1]+8),Vector2(x+25,w[1]+8),Color("c3dedd"),2)
	if spec.id=="a2l1":
		var stopped=State.flags.get("a2l1.source_stopped",false)
		draw_rect(Rect2(470,390,2100,15),Color("66737e"))
		for x in range(490,2560,110):draw_rect(Rect2(x,385,8,25),Color("bac5bf"))
		if not stopped:
			for i in 7:
				var fx=520+fmod(clock*130+i*95,1900)
				draw_rect(Rect2(fx,425,18,7),Color("8b7593"))
			_label(Vector2(510,355),State.text("ATIK YENİDEN GELİYOR ← KAYNAK","WASTE RETURNS ← SOURCE"),Color("344350"),15)
	for g in spec.ground:terrain(Rect2(g[0],g[1],g[2],g[3]),palette,false)
	for p in spec.platforms:terrain(Rect2(p[0],p[1],p[2],p[3]),palette,true)
	if spec.has("tunnel"):
		var t=spec.tunnel;terrain(Rect2(t[0],t[1],t[2],t[3]),palette,true)
		_label(Vector2(t[0]-35,t[1]-18),tunnel_hint(),Color("273f46"),15)
	for m in moving:
		terrain(Rect2(m.body.position-m.size/2,m.size),palette,true)
		draw_line(m.origin-m.amplitude,m.origin+m.amplitude,Color("edf1d3"),2)
	for cp in spec.checkpoints:
		if not visible_x(cp):continue
		draw_rect(Rect2(cp,378,4,62),Color("e9dfc4"));draw_colored_polygon(PackedVector2Array([Vector2(cp+4,378),Vector2(cp+38,385),Vector2(cp+4,399)]),Color("2c8778"))
	for x in range(70,int(end),95):
		if not visible_x(x):continue
		draw_rect(Rect2(x,432,3,8),Color("567b55"));draw_rect(Rect2(x-3,428,9,5),Color("eacb86"))
	for x in range(250,int(end)-100,610):
		if not visible_x(x):continue
		var name="log" if spec.biome in ["meadow","forest"] else "rocks"
		var texture: Texture2D=props[name]
		draw_texture_rect(texture,Rect2(x,397,85,43),false,Color(1,1,1,0.85))
	var arch: Texture2D=props["forest-arch" if spec.biome in ["meadow","forest","river"] else "pipe-arch"]
	draw_texture_rect(arch,Rect2(end-240,270,190,170),false)
	if spec.id=="sanctuary":
		if State.animals.has("duru"):draw_animal(Vector2(480+sin(clock*0.5)*28,440),"care",false)
		if State.flags.get("story_complete",false):
			for x in range(200,2000,40):
				draw_rect(Rect2(x,426,3,14),Color("60916f"));draw_rect(Rect2(x-4,421,11,7),Color("e6b68d"))
		_label(Vector2(1300,340),State.text("BAKIM VE İZLEME SÜRÜYOR","CARE AND MONITORING CONTINUE"),Color("344c4f"),16)
	if not State.prefs.reduced_effects:
		for i in 18:
			var fx=fmod(i*239+clock*7,end);var fy=130+posmod(i*47,210)+sin(clock+i)*10
			draw_rect(Rect2(fx,fy,2,2),Color(0.95,0.88,0.6,0.45))
	for w in spec.get("wind",[]):
		for i in 6:
			var x=float(w[0])+30+i*float(w[2])/6;var y=float(w[1])+fmod(clock*35+i*30,float(w[3]))
			draw_line(Vector2(x,y+18),Vector2(x,y),Color("cee6df"),2);draw_line(Vector2(x,y),Vector2(x-5,y+6),Color("cee6df"),2);draw_line(Vector2(x,y),Vector2(x+5,y+6),Color("cee6df"),2)
	if spec.id=="a5l2":draw_grey_wheel()
	for a in spec.actions:draw_mechanism(a)
	for g in spec.get("gates",[]):
		var r=g.rect
		if not visible_x(r[0]):continue
		if not State.flags.get(g.flag,false):
			draw_rect(Rect2(r[0],r[1],r[2],r[3]),Color("465762"))
			for y in range(int(r[1]),int(r[1]+r[3]),14):draw_line(Vector2(r[0],y),Vector2(r[0]+r[2],y+10),Color("e7bd75"),4)
		else:draw_line(Vector2(r[0],440),Vector2(r[0]+55,420),Color("768577"),8)
	var disabled=State.flags.get(spec.get("hazard_disable",""),false)
	for h in spec.hazards:
		if not visible_x(h[0]):continue
		var pos=Vector2(h[0]+h[2]/2,438)
		var phase=0 if disabled else danger_phase()
		var c=Color("da7064" if phase==2 else ("edc470" if phase==1 else "668a80"))
		draw_rect(Rect2(h[0],434,h[2],6),Color("344953"))
		for i in 6:
			var theta=clock*(3 if phase==2 else 0)+i*TAU/6
			draw_line(pos,pos+Vector2(cos(theta),sin(theta))*27,c,7)
		draw_circle(pos,18,c);draw_circle(pos,8,Color("344953") if phase==0 else c.lightened(0.3))
		if phase==1:
			draw_colored_polygon(PackedVector2Array([pos+Vector2(0,-80),pos+Vector2(-14,-54),pos+Vector2(14,-54)]),c)
			_label(pos+Vector2(-3,-58),"!",Color("293b43"),18)
	if spec.has("animal"):
		var walk=not actor_done and State.has_all(spec.animal.requires)
		draw_animal(Vector2(actor_x,440),spec.animal.habitat,walk)
		if not walk and not actor_done:_label(Vector2(actor_x-25,370),"…",Color("314a52"),24)
	var exit_pos=Vector2(end-100,440)
	draw_rect(Rect2(exit_pos.x,350,9,90),Color("4c6962"));draw_rect(Rect2(exit_pos.x-32,352,74,28),Color("f1dfb2"))
	_label(exit_pos+Vector2(-25,-67),"→",Color("345550"),24)
	if OS.is_debug_build():draw_cpu_usec=Time.get_ticks_usec()-draw_started

func terrain(r: Rect2,palette: Array,raised: bool) -> void:
	draw_rect(r,Color(palette[3]));draw_rect(Rect2(r.position,r.size*Vector2(1,0)+Vector2(0,6)),Color("eee1b2"))
	draw_rect(Rect2(r.position+Vector2(0,6),Vector2(r.size.x,6)),Color("70956c"))
	if raised and r.size.y<=22 and not props.is_empty():
		var texture: Texture2D=props["industrial-left" if spec.biome in ["workshop","town","finale"] else "grass-left"]
		draw_texture_rect(texture,Rect2(r.position+Vector2(-4,-6),Vector2(r.size.x+8,65)),false)
		draw_line(r.position,r.position+Vector2(r.size.x,0),Color("f5e6b8"),3)
	for x in range(int(r.position.x)+8,int(r.end.x),32):
		if not visible_x(x):continue
		draw_rect(Rect2(x,r.position.y+18,16,4),Color(palette[4]).darkened(0.12))
		if not raised:draw_rect(Rect2(x+12,r.position.y+42,8,5),Color(palette[4]).darkened(0.25))

func visible_x(x: float) -> bool:
	return x>=view_bounds.position.x-180 and x<=view_bounds.end.x+180

func tunnel_hint() -> String:
	return State.text("↘ KUZU · ","↘ LAMB · ")+Controls.hint("ability")

func draw_mechanism(a: Dictionary) -> void:
	if not visible_x(float(a.x)):return
	var p=Vector2(a.x,a.y);var done=State.flags.get(a.id,false)
	var c=Color("80c39d" if done else "eac677")
	if a.kind=="friend":return
	draw_rect(Rect2(p+Vector2(-23,-43),Vector2(46,43)),Color("3e5962"))
	match a.kind:
		"record":
			draw_rect(Rect2(p+Vector2(-17,-65),Vector2(34,43)),Color("efdfb5"))
			for y in range(-57,-28,8):draw_line(p+Vector2(-10,y),p+Vector2(10,y),Color("718d89"),3)
		"fan":
			draw_circle(p+Vector2(0,-51),23,Color("687e87"))
			for i in 4:
				var theta=(0 if done or State.prefs.reduced_effects else clock*9)+i*TAU/4
				draw_line(p+Vector2(0,-51),p+Vector2(cos(theta),sin(theta))*20+Vector2(0,-51),c,7)
		"water","valve":
			draw_circle(p+Vector2(0,-49),19,c);draw_line(p+Vector2(-14,-49),p+Vector2(14,-49),Color("426f81"),5)
			if done:
				for i in 3:draw_rect(Rect2(p+Vector2(-16+i*12,-30+fmod(clock*35+i*8,23)),Vector2(4,6)),Color("a8dfdf"))
		"hatch":
			draw_rect(Rect2(p+Vector2(-32,-16),Vector2(64,16)),Color("31424d"))
			var opening=float(mechanism_times.get(a.id,1.0 if done else 0.0))
			var end=p+Vector2(30-48*opening,-20-48*opening)
			draw_line(p+Vector2(-32,-18),end,Color("8e9c9c"),10)
			draw_line(p+Vector2(-18,-15),p+Vector2(-18,-4),c,3)
		"seed":
			draw_rect(Rect2(p+Vector2(-40,-12),Vector2(80,12)),Color("88664e"))
			for i in 4:
				draw_rect(Rect2(p+Vector2(-30+i*18,-15),Vector2(5,4)),Color("c9ac6c"))
				if done:
					draw_line(p+Vector2(-28+i*18,-12),p+Vector2(-28+i*18,-23),Color("80aa76"),2);draw_rect(Rect2(p+Vector2(-33+i*18,-25),Vector2(10,5)),Color("80aa76"))
		"meal":
			draw_rect(Rect2(p+Vector2(-50,-43),Vector2(100,8)),Color("866851"));draw_circle(p+Vector2(0,-49),15,Color("eee2ba"))
			for i in 5:draw_rect(Rect2(p+Vector2(-10+i*4,-51+(i%2)*4),Vector2(4,4)),Color("9a793a" if done else "a8b4ad"))
			if done:_label(p+Vector2(-70,-82),State.text("MERCİMEKLİ SOFRA","LENTIL MEAL"),Color("344e4d"),14)
		"care":
			draw_rect(Rect2(p+Vector2(-35,-43),Vector2(70,12)),Color("eee4c9"));draw_animal(p+Vector2(0,-43),"care",false)
			draw_rect(Rect2(p+Vector2(40,-43),Vector2(18,43)),Color("7ea69c"));draw_circle(p+Vector2(49,-53),10,Color("d8ac84"))
		_:
			draw_line(p+Vector2(0,-35),p+Vector2(20 if done else -20,-65),c,7)
			draw_circle(p+Vector2(20 if done else -20,-65),6,c)
	if done:
		draw_line(p+Vector2(-8,-85),p+Vector2(-1,-78),Color("28594d"),3);draw_line(p+Vector2(-1,-78),p+Vector2(12,-93),Color("28594d"),3)
	else:
		draw_colored_polygon(PackedVector2Array([p+Vector2(0,-91),p+Vector2(-6,-100),p+Vector2(6,-100)]),c)
		if not a.heroes.is_empty():_label(p+Vector2(-5,-105),str(int(a.heroes[0])+1),Color("344e4d"),14)

func draw_animal(p: Vector2,habitat: String,walk: bool) -> void:
	var step=sin(clock*13)*4 if walk else 0.0
	var body=Color("b97f62" if habitat in ["forest","nest"] else "eee2c3")
	draw_rect(Rect2(p+Vector2(-17,-25),Vector2(32,20)),body)
	draw_rect(Rect2(p+Vector2(7,-35),Vector2(20,25)),body.lightened(0.08))
	draw_rect(Rect2(p+Vector2(10,-47),Vector2(6,17)),body);draw_rect(Rect2(p+Vector2(20,-44),Vector2(5,13)),body)
	draw_rect(Rect2(p+Vector2(21,-29),Vector2(3,4)),Color("34434a"))
	draw_rect(Rect2(p+Vector2(-12+step,-7),Vector2(6,7)),body.darkened(0.25));draw_rect(Rect2(p+Vector2(11-step,-7),Vector2(6,7)),body.darkened(0.25))
	if habitat=="forest":draw_colored_polygon(PackedVector2Array([p+Vector2(-16,-17),p+Vector2(-44,-27),p+Vector2(-30,-7)]),body)

func _label(pos: Vector2,value: String,color: Color,size: int=16) -> void:
	draw_string(PlanetSkin.FONT,pos,value,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)

func draw_grey_wheel() -> void:
	var centre=Vector2(2100,220)
	var stopped=State.flags.get("a5l2.inner_system_stopped",false)
	var stage=3 if State.flags.get("a5l2.exit_protected",false) else (2 if stopped else (1 if State.flags.get("a5l2.pattern_observed",false) else 0))
	var rotation_clock=0.0 if stopped else clock*0.24
	# One visible machine spans the three objective stages; live subsystems have their own signs.
	draw_rect(Rect2(centre+Vector2(-150,-100),Vector2(300,300)),Color("384c58"))
	for i in 16:
		var angle=rotation_clock+i*TAU/16
		var tip=centre+Vector2(cos(angle),sin(angle))*123
		draw_rect(Rect2(tip-Vector2(11,11),Vector2(22,22)),Color("b8a279"))
	draw_circle(centre,110,Color("bc9e70"));draw_circle(centre,92,Color("425b62"))
	for i in 8:
		var angle=rotation_clock+i*TAU/8
		draw_line(centre,centre+Vector2(cos(angle),sin(angle))*90,Color("80928f"),14)
	draw_circle(centre,30,Color("7dbb99" if stopped else "d78d70"))
	for i in 3:
		var p=centre+Vector2(-60+i*60,155)
		draw_rect(Rect2(p,Vector2(40,14)),Color("83bd98" if i<stage else "a1a69b"))
	_label(centre+Vector2(-77,-145),State.text("GRİ ÇARK · ","GREY WHEEL · ")+str(stage)+" / 3",Color("f1e6bd"),18)

func draw_backdrop(palette: Array,end: float) -> void:
	# Palette roles and stepped silhouettes are shared by all ten chapters.
	var sky_top=Color("203b52").lerp(Color(palette[0]),0.20)
	var sky_bottom=Color(palette[1]).darkened(0.08)
	# Extend the original gradient at either edge, retaining its world-space bands.
	# A very tall portrait camera can see above -300; a wide camera sees past x+994.
	var sky_left=view_bounds.position.x-16
	var sky_width=view_bounds.size.x+32
	if view_bounds.position.y< -300:
		draw_rect(Rect2(sky_left,view_bounds.position.y-16,sky_width,-300-view_bounds.position.y+16),sky_top)
	if view_bounds.end.y>492:
		draw_rect(Rect2(sky_left,492,sky_width,view_bounds.end.y-492+16),sky_bottom)
	for i in 18:
		var y=-300+i*44
		if y+45<view_bounds.position.y or y>view_bounds.end.y:continue
		draw_rect(Rect2(sky_left,y,sky_width,45),sky_top.lerp(sky_bottom,float(i)/17.0))
	var sun=Vector2(camera_x+745,111)
	draw_rect(Rect2(sun+Vector2(-34,-42),Vector2(68,84)),Color("e5d6a1"))
	draw_rect(Rect2(sun+Vector2(-42,-29),Vector2(84,58)),Color("e5d6a1"))
	for layer in 3:
		var parallax=[0.84,0.62,0.38][layer]
		var color=[Color("62838a"),Color("476e78"),Color("2c5360")][layer]
		for x in range(-600,int(end)+1000,300):
			var base=roundf(x+camera_x*parallax)
			if base<view_bounds.position.x-400 or base>view_bounds.end.x+300:continue
			var h=110+posmod(x*7+layer*45,95)
			var y=265+layer*38
			var points=PackedVector2Array([Vector2(base,440),Vector2(base,y+30),Vector2(base+30,y+30),Vector2(base+30,y),Vector2(base+60,y),Vector2(base+60,y-h/3.0),Vector2(base+100,y-h/3.0),Vector2(base+100,y-h/2.0),Vector2(base+145,y-h/2.0),Vector2(base+145,y-h/3.0),Vector2(base+200,y-h/3.0),Vector2(base+200,y),Vector2(base+280,y),Vector2(base+280,440)])
			draw_colored_polygon(points,color)
	# Small distant silhouettes are project-local scenery, not new canon locations.
	for x in range(300,int(end)+600,730):
		var px=roundf(x+camera_x*0.68)
		if not visible_x(px):continue
		draw_rect(Rect2(px,246,20,85),Color("3c606c"));draw_rect(Rect2(px+27,222,13,109),Color("3c606c"));draw_rect(Rect2(px+2,264,38,10),Color("6f9394"))
	for x in range(90,int(end)+250,265):
		if not visible_x(x):continue
		if spec.biome in ["workshop","town","finale"]:
			draw_rect(Rect2(x,285,145,155),Color("3a5664"));draw_rect(Rect2(x-6,276,157,12),Color("67818b"))
			for w in range(15,133,30):
				draw_rect(Rect2(x+w,302,14,22),Color("b5b58e"));draw_rect(Rect2(x+w,345,14,25),Color("6e9295"))
			draw_rect(Rect2(x+96,219,18,59),Color("3a5664"));draw_rect(Rect2(x+89,213,32,8),Color("829d9c"))
		else:draw_tree(Vector2(x,440),posmod(x,3))
	# Foreground roots and grass use larger silhouettes, not a repeated noisy texture.
	for x in range(0,int(end),38):
		if not visible_x(x):continue
		draw_rect(Rect2(x,432,3,8),Color("618e78"));draw_line(Vector2(x,435),Vector2(x-5,429),Color("86aa83"),2)
		if posmod(x,5)==0:draw_rect(Rect2(x-2,427,7,4),Color("d6c28e"))

func draw_tree(foot: Vector2,variant: int) -> void:
	var top=foot+Vector2(0,-160-variant*13)
	draw_rect(Rect2(foot+Vector2(-10,-180),Vector2(20,180)),Color("516660"))
	draw_rect(Rect2(foot+Vector2(-7,-160),Vector2(4,143)),Color("879077"))
	for offset in [Vector2(-15,8),Vector2(24,-40),Vector2(-16,-79)]:
		var p=top+offset
		var points=PackedVector2Array([p+Vector2(-54,8),p+Vector2(-54,-12),p+Vector2(-42,-12),p+Vector2(-42,-30),p+Vector2(-22,-30),p+Vector2(-22,-43),p+Vector2(14,-43),p+Vector2(14,-33),p+Vector2(37,-33),p+Vector2(37,-14),p+Vector2(53,-14),p+Vector2(53,8),p+Vector2(40,8),p+Vector2(40,27),p+Vector2(13,27),p+Vector2(13,36),p+Vector2(-24,36),p+Vector2(-24,25),p+Vector2(-44,25),p+Vector2(-44,8)])
		draw_colored_polygon(points,Color("345e61"))
		draw_rect(Rect2(p+Vector2(-30,-28),Vector2(48,7)),Color("5f8b7e"));draw_rect(Rect2(p+Vector2(-41,-12),Vector2(29,8)),Color("517f75"));draw_rect(Rect2(p+Vector2(10,9),Vector2(28,6)),Color("416d69"))
		for i in 5:draw_rect(Rect2(p+Vector2(-27+i*13,-4-posmod(i*7,13)),Vector2(5,3)),Color("729887"))
	draw_line(foot+Vector2(-27,-1),foot+Vector2(0,-12),Color("5c7465"),5);draw_line(foot+Vector2(0,-12),foot+Vector2(25,-1),Color("5c7465"),5)
