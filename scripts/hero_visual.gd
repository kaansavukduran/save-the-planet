class_name HeroVisual
extends Node2D
const META=preload("res://data/sprites.json")
const HEROES=["aion","wolf","sheep","owl"]
static var cache: Dictionary = {}
static var used_rects: Dictionary = {}
var hero=0
var pose="idle"
var facing=1
var clock=0.0
var previous_pose=""
var sprite: Sprite2D
func _ready() -> void:
	sprite=Sprite2D.new();sprite.centered=false;add_child(sprite)
func _process(delta: float) -> void:
	if previous_pose!=pose:clock=0.0;previous_pose=pose
	clock+=delta
	refresh()
func refresh() -> void:
	if sprite==null:return
	var atlas="canonical-"+HEROES[hero]
	var row=0
	match pose:
		"run","walk":row=1
		"jump","rise","fall":row=2
		"land":row=2
		"interact":row=3
		"rest":row=10
		"roll":atlas="canonical-rolls";row=[0,3,2,1][hero]
		"dash":atlas="agility-wolf";row=0
		"glide":atlas="agility-owl";row=0
	for r in META.data[atlas]:
		if int(r.row)!=row:continue
		var frames: Array=r.frames
		var index=posmod(int(clock*(13 if pose in ["run","roll","dash"] else 7)),frames.size())
		if pose=="rise":index=mini(int(clock*11),2)
		if pose=="fall":index=mini(3+int(clock*9),frames.size()-2)
		if pose=="land":index=frames.size()-1
		var f: Dictionary=frames[index]
		if not cache.has(f.texture):cache[f.texture]=load(f.texture)
		sprite.texture=cache[f.texture]
		var factor=float(f.scale)*0.72
		sprite.scale=Vector2(factor*facing,factor)
		# Keep the sprite node at the physical body's origin. Texture-space offsets
		# flip around that same origin and avoid per-frame rounding of the feet.
		sprite.position=Vector2.ZERO
		sprite.offset=-Vector2(float(f.anchor[0]),float(f.anchor[1]))
		return

func render_snapshot() -> Dictionary:
	# Read-only render diagnostics, called by native tests and debug Web QA only.
	if sprite==null or sprite.texture==null:return {}
	var path=sprite.texture.resource_path
	if not used_rects.has(path):
		var pixels=sprite.texture.get_image()
		if pixels.is_compressed():pixels.decompress()
		used_rects[path]=Rect2(pixels.get_used_rect())
	var visible: Rect2=used_rects[path]
	visible.position+=sprite.offset
	var bounds: Rect2=sprite.get_global_transform_with_canvas()*visible
	var anchor=get_global_transform_with_canvas().origin
	return {"hero":hero,"pose":pose,"facing":facing,"texture":path,"root":[anchor.x,anchor.y],"opaque_bounds":[bounds.position.x,bounds.position.y,bounds.size.x,bounds.size.y],"sprite_position":[sprite.position.x,sprite.position.y]}
