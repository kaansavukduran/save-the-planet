extends Node
signal method_changed
signal controller_lost
const KEYS = {"left":[KEY_A,KEY_LEFT],"right":[KEY_D,KEY_RIGHT],"down":[KEY_S,KEY_DOWN],"jump":[KEY_SPACE],"ability":[KEY_J],"interact":[KEY_E],"party":[KEY_Q],"pause":[KEY_ESCAPE],"journal":[KEY_TAB],"hero0":[KEY_1],"hero1":[KEY_2],"hero2":[KEY_3],"hero3":[KEY_4],"hero_prev":[],"hero_next":[]}
const PAD = {"jump":JOY_BUTTON_A,"ability":JOY_BUTTON_X,"interact":JOY_BUTTON_B,"party":JOY_BUTTON_Y,"pause":JOY_BUTTON_START,"journal":JOY_BUTTON_BACK,"left":JOY_BUTTON_DPAD_LEFT,"right":JOY_BUTTON_DPAD_RIGHT,"down":JOY_BUTTON_DPAD_DOWN,"hero_prev":JOY_BUTTON_LEFT_SHOULDER,"hero_next":JOY_BUTTON_RIGHT_SHOULDER}
const REMAPPABLE_PAD = ["jump","ability","interact","party","journal","hero_prev","hero_next"]
const NAMES = {"left":["Sola git","Move left"],"right":["Sağa git","Move right"],"down":["Platformdan in","Drop through platform"],"jump":["Zıpla / süzül","Jump / glide"],"ability":["Yetenek","Ability"],"interact":["Etkileşim","Interact"],"party":["Takım","Party"],"pause":["Duraklat","Pause"],"journal":["Defter","Journal"],"hero_prev":["Önceki karakter","Previous hero"],"hero_next":["Sonraki karakter","Next hero"]}
var touch_ids: Dictionary = {}
var input_method = "keyboard"
var controller_device = -1
var binding_notice = ""

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	for action in KEYS:
		InputMap.add_action(action)
	reset_keyboard(false)
	for pair in [["ui_accept",JOY_BUTTON_A],["ui_cancel",JOY_BUTTON_B]]:
		var event=InputEventJoypadButton.new()
		event.button_index=pair[1]
		InputMap.action_add_event(pair[0],event)
	reset_gamepad(false)
	for direction in 2:
		var event=InputEventJoypadMotion.new()
		event.axis=JOY_AXIS_LEFT_X
		event.axis_value=-1 if direction==0 else 1
		InputMap.action_add_event("left" if direction==0 else "right",event)
	apply_deadzone()
	for action in State.prefs.bindings:
		if KEYS.has(action):rebind(action,int(State.prefs.bindings[action]),false)
	for action in State.prefs.gamepad_bindings:
		if action in REMAPPABLE_PAD:rebind_gamepad(action,int(State.prefs.gamepad_bindings[action]),false)
	Input.joy_connection_changed.connect(connection_changed)

func action_name(action: String) -> String:
	if action.begins_with("hero") and action.right(1).is_valid_int():
		return State.text("Karakter ","Hero ")+str(int(action.right(1))+1)
	var pair=NAMES.get(action,[action,action])
	return State.text(pair[0],pair[1])

func pad_name(code: int) -> String:
	return {JOY_BUTTON_A:"A",JOY_BUTTON_B:"B",JOY_BUTTON_X:"X",JOY_BUTTON_Y:"Y",JOY_BUTTON_LEFT_SHOULDER:"LB",JOY_BUTTON_RIGHT_SHOULDER:"RB",JOY_BUTTON_START:"Start",JOY_BUTTON_BACK:"View",JOY_BUTTON_LEFT_STICK:"LS",JOY_BUTTON_RIGHT_STICK:"RS",JOY_BUTTON_DPAD_LEFT:"D-pad ◀",JOY_BUTTON_DPAD_RIGHT:"D-pad ▶",JOY_BUTTON_DPAD_DOWN:"D-pad ▼"}.get(code,State.text("Düğme ","Button ")+str(code))

func hint(action: String,method: String="") -> String:
	var device=input_method if method=="" else method
	for event in InputMap.action_get_events(action):
		if device=="gamepad" and event is InputEventJoypadButton:return pad_name(event.button_index)
		if device!="gamepad" and event is InputEventKey:return OS.get_keycode_string(event.physical_keycode)
	return "LB / RB" if action.begins_with("hero") else action_name(action)

func menu_hint(accept: bool) -> String:
	return ("A" if accept else "B") if input_method=="gamepad" else ("Enter" if accept else "Esc")

func set_method(method: String) -> void:
	if input_method!=method:
		input_method=method
		method_changed.emit()

func reset_keyboard(persist: bool=true) -> void:
	for action in KEYS:
		for event in InputMap.action_get_events(action):
			if event is InputEventKey:InputMap.action_erase_event(action,event)
		for code in KEYS[action]:
			var event=InputEventKey.new()
			event.physical_keycode=code
			InputMap.action_add_event(action,event)
	if persist:
		State.prefs.bindings.clear()
		State.save_preferences()

func reset_gamepad(persist: bool=true) -> void:
	for action in PAD:
		for event in InputMap.action_get_events(action):
			if event is InputEventJoypadButton:InputMap.action_erase_event(action,event)
		var event=InputEventJoypadButton.new()
		event.button_index=PAD[action]
		InputMap.action_add_event(action,event)
	if persist:
		State.prefs.gamepad_bindings.clear()
		State.save_preferences()

func rebind(action: String,key: int,persist: bool=true) -> bool:
	if not KEYS.has(action):return false
	if key==KEY_F1:
		binding_notice=State.text("F1 yardım rehberine ayrılmıştır.","F1 is reserved for the help guide.")
		return false
	for other in KEYS:
		if other==action:continue
		for event in InputMap.action_get_events(other):
			if event is InputEventKey and event.physical_keycode==key:
				binding_notice=State.text("Bu tuş kullanımda: ","Key already used: ")+action_name(other)
				return false
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:InputMap.action_erase_event(action,event)
	var event=InputEventKey.new()
	event.physical_keycode=key
	InputMap.action_add_event(action,event)
	if persist:
		State.prefs.bindings[action]=key
		State.save_preferences()
	return true

func rebind_gamepad(action: String,code: int,persist: bool=true) -> bool:
	if not action in REMAPPABLE_PAD:return false
	for other in PAD:
		if other==action:continue
		for event in InputMap.action_get_events(other):
			if event is InputEventJoypadButton and event.button_index==code:
				binding_notice=State.text("Bu düğme kullanımda: ","Button already used: ")+action_name(other)
				return false
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton:InputMap.action_erase_event(action,event)
	var event=InputEventJoypadButton.new()
	event.button_index=code
	InputMap.action_add_event(action,event)
	if persist:
		State.prefs.gamepad_bindings[action]=code
		State.save_preferences()
	return true

func apply_deadzone() -> void:
	for action in ["left","right","ui_left","ui_right","ui_up","ui_down"]:
		InputMap.action_set_deadzone(action,float(State.prefs.deadzone))

func connection_changed(device: int,connected: bool) -> void:
	if not connected and input_method=="gamepad" and device==controller_device:
		release_all()
		controller_device=-1
		controller_lost.emit()

func release_all() -> void:
	for action in KEYS:Input.action_release(action)
	touch_ids.clear()

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED,NOTIFICATION_WM_WINDOW_FOCUS_OUT]:
		release_all()
		State.save_game()

func touch_rects(size: Vector2) -> Dictionary:
	var side=clampf(size.x/12.0,48,76)
	return {"left":Rect2(18,size.y-side-16,side,side),"right":Rect2(24+side,size.y-side-16,side,side),"jump":Rect2(size.x-side-18,size.y-side-16,side,side),"ability":Rect2(size.x-2*side-26,size.y-side-16,side,side),"interact":Rect2(size.x-side-18,size.y-2*side-24,side,side)}

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or (event is InputEventMouseButton and event.device>=0)) and event.is_pressed():set_method("keyboard")
	if (event is InputEventJoypadButton and event.pressed) or (event is InputEventJoypadMotion and absf(event.axis_value)>float(State.prefs.deadzone)):
		controller_device=event.device
		set_method("gamepad")
	if event is InputEventScreenTouch and event.pressed:set_method("touch")
	if not (OS.has_feature("mobile") or State.prefs.touch):return
	if event is InputEventScreenTouch:
		if event.pressed and not get_tree().paused:
			var rects=touch_rects(get_viewport().get_visible_rect().size)
			for action in rects:
				if rects[action].has_point(event.position):
					touch_ids[event.index]=action
					Input.action_press(action)
					get_viewport().set_input_as_handled()
					break
		elif touch_ids.has(event.index):
			var action=touch_ids[event.index]
			touch_ids.erase(event.index)
			if not action in touch_ids.values():Input.action_release(action)
			get_viewport().set_input_as_handled()
	if event is InputEventScreenDrag and touch_ids.has(event.index):
		var action=touch_ids[event.index]
		if not touch_rects(get_viewport().get_visible_rect().size)[action].grow(20).has_point(event.position):
			touch_ids.erase(event.index)
			if not action in touch_ids.values():Input.action_release(action)
