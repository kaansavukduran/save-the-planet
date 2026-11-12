extends Node
const KEYS = {"left":[KEY_A,KEY_LEFT],"right":[KEY_D,KEY_RIGHT],"down":[KEY_S,KEY_DOWN],"jump":[KEY_SPACE],"ability":[KEY_J],"interact":[KEY_E],"party":[KEY_Q],"pause":[KEY_ESCAPE],"journal":[KEY_TAB],"hero0":[KEY_1],"hero1":[KEY_2],"hero2":[KEY_3],"hero3":[KEY_4]}
var touch_ids: Dictionary = {}
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	for action in KEYS:
		InputMap.add_action(action)
		for key in KEYS[action]:
			var e=InputEventKey.new();e.physical_keycode=key;InputMap.action_add_event(action,e)
	for pair in [["ui_accept",JOY_BUTTON_A],["ui_cancel",JOY_BUTTON_B]]:
		var menu_event=InputEventJoypadButton.new();menu_event.button_index=pair[1];InputMap.action_add_event(pair[0],menu_event)
	var buttons={"down":JOY_BUTTON_DPAD_DOWN,"jump":JOY_BUTTON_A,"ability":JOY_BUTTON_X,"interact":JOY_BUTTON_B,"party":JOY_BUTTON_Y,"pause":JOY_BUTTON_START,"journal":JOY_BUTTON_BACK,"left":JOY_BUTTON_DPAD_LEFT,"right":JOY_BUTTON_DPAD_RIGHT}
	for a in buttons:
		var e=InputEventJoypadButton.new();e.button_index=buttons[a];InputMap.action_add_event(a,e)
	for i in 2:
		var e=InputEventJoypadMotion.new();e.axis=JOY_AXIS_LEFT_X;e.axis_value=-1 if i==0 else 1;InputMap.action_add_event("left" if i==0 else "right",e)
	for a in State.prefs.bindings:
		if KEYS.has(a):rebind(a,int(State.prefs.bindings[a]),false)

func rebind(action: String,key: int,persist: bool=true) -> void:
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:InputMap.action_erase_event(action,e)
	var e=InputEventKey.new();e.physical_keycode=key;InputMap.action_add_event(action,e)
	if persist:
		State.prefs.bindings[action]=key;State.save_game()

func release_all() -> void:
	for a in KEYS:Input.action_release(a)
	touch_ids.clear()

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED,NOTIFICATION_WM_WINDOW_FOCUS_OUT]:
		release_all();State.save_game()

func touch_rects(size: Vector2) -> Dictionary:
	var s=clampf(size.x/12.0,48,76)
	return {"left":Rect2(18,size.y-s-16,s,s),"right":Rect2(24+s,size.y-s-16,s,s),"jump":Rect2(size.x-s-18,size.y-s-16,s,s),"ability":Rect2(size.x-2*s-26,size.y-s-16,s,s),"interact":Rect2(size.x-s-18,size.y-2*s-24,s,s)}

func _input(event: InputEvent) -> void:
	if not (OS.has_feature("mobile") or State.prefs.touch):return
	if event is InputEventScreenTouch:
		if event.pressed and not get_tree().paused:
			for a in touch_rects(get_viewport().get_visible_rect().size):
				if touch_rects(get_viewport().get_visible_rect().size)[a].has_point(event.position):
					touch_ids[event.index]=a;Input.action_press(a);get_viewport().set_input_as_handled();break
		elif touch_ids.has(event.index):
			var action=touch_ids[event.index];touch_ids.erase(event.index)
			if not action in touch_ids.values():Input.action_release(action)
			get_viewport().set_input_as_handled()
	if event is InputEventScreenDrag and touch_ids.has(event.index):
		var action=touch_ids[event.index]
		if not touch_rects(get_viewport().get_visible_rect().size)[action].grow(20).has_point(event.position):
			touch_ids.erase(event.index)
			if not action in touch_ids.values():Input.action_release(action)
