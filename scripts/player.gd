class_name PlanetPlayer
extends CharacterBody2D
signal used_ability
signal feedback(tr_text: String,en_text: String)
signal retried
const SPEED=225.0
const GRAVITY=1250.0
var coyote=0.0
var buffer=0.0
var jumps=0
var glide_left=1.4
var cooldown=0.0
var action_time=0.0
var dash_time=0.0
var roll_time=0.0
var invulnerable=0.0
var facing=1
var spawn=Vector2(100,440)
var body_shape: CollisionShape2D
var visual: HeroVisual
var landing=0.0
var was_floor=false
var blocked=false
var drop_time=0.0
var wind=Vector2.ZERO
func _ready() -> void:
	body_shape=CollisionShape2D.new();body_shape.shape=RectangleShape2D.new();body_shape.shape.size=Vector2(30,54);body_shape.position.y=-27;add_child(body_shape)
	visual=HeroVisual.new();add_child(visual)
	floor_snap_length=8;collision_mask=3;platform_floor_layers=3

func set_short(short_body: bool) -> void:
	body_shape.shape.size=Vector2(30,26 if short_body else 54)
	body_shape.position.y=-13 if short_body else -27

func can_stand() -> bool:
	var query=PhysicsShapeQueryParameters2D.new();var shape=RectangleShape2D.new();shape.size=Vector2(29,53)
	query.shape=shape;query.transform=Transform2D(0,global_position+Vector2(0,-28));query.exclude=[get_rid()];query.collision_mask=1
	return get_world_2d().direct_space_state.intersect_shape(query).is_empty()

func switch_hero(id: int) -> bool:
	if not id in State.unlocked:return false
	if id!=2 and (roll_time>0 or body_shape.shape.size.y<40) and not can_stand():
		feedback.emit("Dar geçit: önce açık alana çık.","Low tunnel: reach open space first.");return false
	State.active=id
	# Shared resources deliberately untouched: jumps, glide, cooldown, dash and immunity.
	visual.hero=id;return true

func retry() -> void:
	position=spawn;velocity=Vector2.ZERO;jumps=0;glide_left=1.4;dash_time=0;roll_time=0;buffer=0;coyote=0;invulnerable=1.2;set_short(false)
	var cam=get_node_or_null("Camera2D")
	if cam:cam.reset_smoothing();cam.force_update_scroll()
	retried.emit()

func _physics_process(dt: float) -> void:
	cooldown=maxf(0,cooldown-dt);action_time=maxf(0,action_time-dt);dash_time=maxf(0,dash_time-dt);roll_time=maxf(0,roll_time-dt);invulnerable=maxf(0,invulnerable-dt);landing=maxf(0,landing-dt)
	if blocked:return
	drop_time=maxf(0,drop_time-dt)
	if Input.is_action_pressed("down") and is_on_floor():drop_time=0.25
	set_collision_mask_value(2,drop_time<=0)
	var on_floor=is_on_floor()
	if on_floor:
		if not was_floor:landing=0.16
		coyote=0.13;jumps=0;glide_left=1.4
	else:coyote=maxf(0,coyote-dt)
	buffer=maxf(0,buffer-dt)
	if Input.is_action_just_pressed("jump"):buffer=0.13
	if buffer>0 and (on_floor or coyote>0 or (State.active==0 and jumps<2)):
		if not on_floor and coyote<=0 and jumps==0:jumps=1
		velocity.y=-445.0;buffer=0;coyote=0;jumps+=1
	if Input.is_action_just_released("jump") and velocity.y < -150:velocity.y*=0.55
	var axis=Input.get_axis("left","right")
	if absf(axis)>0.1:facing=1 if axis>0 else -1
	if Input.is_action_just_pressed("ability") and cooldown<=0:
		cooldown=0.9;action_time=0.38
		if State.active==1:dash_time=0.2
		if State.active==2:roll_time=0.6
		used_ability.emit()
		if get_tree().paused:return
	if roll_time>0 or (body_shape.shape.size.y<40 and not can_stand()):set_short(true)
	else:set_short(false)
	if dash_time>0:velocity.x=facing*420
	elif roll_time>0:velocity.x=facing*270
	else:velocity.x=move_toward(velocity.x,axis*SPEED,1800*dt)
	velocity.x=clampf(velocity.x,-420,420)
	velocity.y=minf(velocity.y+GRAVITY*dt,700)
	var using_current=State.active==3 and wind.y<0 and not on_floor and Input.is_action_pressed("jump") and glide_left>0
	var gliding=State.active==3 and not on_floor and (velocity.y>0 or using_current) and Input.is_action_pressed("jump") and glide_left>0
	if gliding:
		velocity.y=-95 if using_current else minf(velocity.y,85);glide_left=maxf(0,glide_left-dt)
	move_and_slide();position.x=maxf(20,position.x)
	if position.y>650:retry()
	visual.hero=State.active;visual.facing=facing
	visual.pose="glide" if gliding else ("dash" if dash_time>0 else ("roll" if body_shape.shape.size.y<40 else ("interact" if action_time>0 else (("rise" if velocity.y<0 else "fall") if not is_on_floor() else ("land" if landing>0 else (("run" if absf(velocity.x)>110 else "walk") if absf(velocity.x)>15 else "idle"))))))
	visual.modulate.a=0.55 if invulnerable>0 and not State.prefs.reduced_effects and int(invulnerable*12)%2==0 else 1.0
	was_floor=is_on_floor()
