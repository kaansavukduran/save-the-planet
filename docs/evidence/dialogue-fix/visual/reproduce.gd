extends SceneTree
func _initialize() -> void:call_deferred("run")
func run() -> void:
 await process_frame
 var state=root.get_node("State");state.path="user://dialogue-visual-proof.json";state.new_game()
 var game=load("res://scenes/main.tscn").instantiate();root.add_child(game);root.size=Vector2i(2048,1024)
 for i in 6:await process_frame
 for language in ["tr","en"]:
  game.ui.close_panel();state.prefs.language=language;game.ui.apply_preferences();game.load_level(1,false,false)
  Input.action_press("right")
  for i in 72:await physics_frame
  Input.action_release("right")
  for i in 8:await physics_frame
  var event=InputEventKey.new();event.physical_keycode=KEY_E;event.pressed=true;Input.parse_input_event(event)
  for i in 6:await process_frame
  event=InputEventKey.new();event.physical_keycode=KEY_E;event.pressed=false;Input.parse_input_event(event)
  for i in 6:await process_frame
  assert(game.ui.menu_kind=="dialogue" and game.ui.dialogue_name.text in ["Kurt","Wolf"])
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/evidence/dialogue-fix/visual/"+language+"-wolf.png")
 game.queue_free();await process_frame;quit()
