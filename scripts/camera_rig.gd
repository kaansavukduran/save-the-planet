class_name PlanetCamera
extends Camera2D
## One camera follows the shared body; look-ahead changes with movement, never hero identity.
func _ready() -> void:
	position=Vector2(110,-170);position_smoothing_enabled=true;position_smoothing_speed=8
	get_viewport().size_changed.connect(adapt_view)
	adapt_view()
func adapt_view() -> void:
	var view=get_viewport().get_visible_rect().size
	var portrait=view.y>view.x
	# Keep feet above the touch region in portrait without moving the physics body.
	# The sky expands upward; world coordinates and save checkpoints stay intact.
	var feet=view.y-245.0 if portrait else 440.0
	position.y=view.y/2.0-feet
	limit_top=int(440.0-feet)
	limit_bottom=int(limit_top+view.y)
	reset_smoothing()

func _physics_process(dt: float) -> void:
	var body=get_parent() as CharacterBody2D
	if body:
		position_smoothing_enabled=not State.prefs.reduced_effects
		if State.prefs.reduced_effects:
			position.x=50.0
			return
		var reach=minf(140.0,get_viewport().get_visible_rect().size.x*0.18)
		var target=clampf(body.velocity.x*0.52,-reach,reach)
		if absf(body.velocity.x)<20:target=50.0
		position.x=move_toward(position.x,target,230*dt)
