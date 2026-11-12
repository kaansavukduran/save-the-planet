class_name PlanetCamera
extends Camera2D
## One camera follows the shared body; look-ahead changes with movement, never hero identity.
func _ready() -> void:
	position=Vector2(110,-170);position_smoothing_enabled=true;position_smoothing_speed=8
func _physics_process(dt: float) -> void:
	var body=get_parent() as CharacterBody2D
	if body:
		position_smoothing_enabled=not State.prefs.reduced_effects
		if State.prefs.reduced_effects:
			position.x=50.0
			return
		var target=clampf(body.velocity.x*0.52,-110,140)
		if absf(body.velocity.x)<20:target=50.0
		position.x=move_toward(position.x,target,230*dt)
