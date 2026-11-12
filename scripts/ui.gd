class_name PlanetUI
extends CanvasLayer
var game: Node2D
var root: Control
var hud: Label
var prompt: Label
var toast: Label
var touch_layer: Control
var modal: PanelContainer
var list: VBoxContainer
var modal_stack: VBoxContainer
var footer_actions: VBoxContainer
var focus_assigned=false
var menu_kind=""
var pending_binding=""
var toast_left=0.0
var title_friends: Array = []
var hud_plate: PanelContainer
var chapter: Label
var party_bar: HBoxContainer
var party_buttons: Array = []
var resource_label: Label
var dimmer: ColorRect
var prompt_plate: PanelContainer
var dialogue_pages: Array = []
var party_signature=""
var settings_origin="title"
var binding_device="keyboard"
var save_status: Label
var title_hint: Label
var dialogue_next: Button
var dialogue_skip: Button
var hint_revision=""
var pause_button: Button
var theme_clock=0.0
var touch_boxes: Dictionary={}

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	PlanetSkin.configure(State.prefs)
	var theme=PlanetSkin.theme()
	root=Control.new();root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);root.mouse_filter=Control.MOUSE_FILTER_IGNORE;root.theme=theme;add_child(root)
	get_viewport().size_changed.connect(apply_preferences)
	hud_plate=PanelContainer.new();hud_plate.position=Vector2(16,16);hud_plate.size=Vector2(660,86);hud_plate.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud_plate.add_theme_stylebox_override("panel",PlanetSkin.box(PlanetSkin.INK,Color("587780"),0));root.add_child(hud_plate)
	chapter=Label.new();chapter.position=Vector2(32,24);chapter.size=Vector2(625,22);chapter.add_theme_font_size_override("font_size",13);chapter.add_theme_color_override("font_color",PlanetSkin.GOLD);root.add_child(chapter)
	hud=Label.new();hud.position=Vector2(32,47);hud.size=Vector2(625,50);hud.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;hud.add_theme_color_override("font_color",Color("f6efcc"));root.add_child(hud)
	var menu=Button.new();menu.text="Ⅱ";menu.focus_mode=Control.FOCUS_NONE;menu.tooltip_text=State.text("Duraklat / Esc","Pause / Esc");menu.position=Vector2(890,12);menu.size=Vector2(48,44);menu.pressed.connect(show_pause);root.add_child(menu)
	pause_button=menu
	menu.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT);menu.offset_left=-68;menu.offset_right=-20;menu.offset_top=12;menu.offset_bottom=56
	prompt_plate=PanelContainer.new();prompt_plate.mouse_filter=Control.MOUSE_FILTER_IGNORE;prompt_plate.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE);prompt_plate.offset_left=210;prompt_plate.offset_right=-210;prompt_plate.offset_top=-187;prompt_plate.offset_bottom=-123;prompt_plate.add_theme_stylebox_override("panel",PlanetSkin.box(PlanetSkin.INK,PlanetSkin.GOLD,10));root.add_child(prompt_plate)
	prompt=Label.new();prompt.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;prompt.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;prompt.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE);prompt.offset_top=-177;prompt.offset_bottom=-128;prompt.offset_left=225;prompt.offset_right=-225
	prompt.add_theme_color_override("font_color",Color("fff0b6"));prompt.add_theme_color_override("font_shadow_color",Color("173b43"));prompt.add_theme_constant_override("shadow_offset_x",2);prompt.add_theme_constant_override("shadow_offset_y",2);root.add_child(prompt)
	toast=Label.new();toast.position=Vector2(32,108);toast.size=Vector2(720,44);toast.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;toast.add_theme_color_override("font_color",Color("fff3c7"));toast.add_theme_color_override("font_shadow_color",Color("173b43"));toast.add_theme_constant_override("shadow_offset_x",2);toast.add_theme_constant_override("shadow_offset_y",2);root.add_child(toast)
	party_bar=HBoxContainer.new();party_bar.position=Vector2(16,470);party_bar.add_theme_constant_override("separation",7);root.add_child(party_bar)
	for i in 4:
		var b=Button.new();b.text=str(i+1);b.focus_mode=Control.FOCUS_NONE;b.custom_minimum_size=Vector2(62,56);b.expand_icon=true;b.add_theme_constant_override("icon_max_width",35);b.pressed.connect(func():game.player.switch_hero(i));party_bar.add_child(b);party_buttons.append(b)
	resource_label=Label.new();resource_label.position=Vector2(300,482);resource_label.add_theme_font_size_override("font_size",14);root.add_child(resource_label)
	save_status=Label.new();save_status.position=Vector2(700,70);save_status.size=Vector2(225,65);save_status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;save_status.add_theme_color_override("font_color",PlanetSkin.GOLD);root.add_child(save_status)
	dimmer=ColorRect.new();dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);dimmer.color=Color(0.025,0.055,0.09,0.55);dimmer.visible=false;root.add_child(dimmer)
	touch_layer=Control.new();touch_layer.mouse_filter=Control.MOUSE_FILTER_IGNORE;root.add_child(touch_layer)
	apply_preferences()

func is_portrait() -> bool:return get_viewport().get_visible_rect().size.y>get_viewport().get_visible_rect().size.x

func refresh_skin(node: Node,old_colors: Array) -> void:
	if node is Control:
		if node.has_theme_font_override("font"):node.add_theme_font_override("font",PlanetSkin.BOLD)
		if node.has_theme_color_override("font_color"):
			var color=node.get_theme_color("font_color")
			for i in old_colors.size():
				if color.is_equal_approx(old_colors[i]):node.add_theme_color_override("font_color",[PlanetSkin.PAPER,PlanetSkin.GOLD,PlanetSkin.SAGE][i]);break
	for child in node.get_children():refresh_skin(child,old_colors)

func place(control: Control,rect: Rect2) -> void:
	control.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	control.position=rect.position;control.size=rect.size

func arrange() -> void:
	if hud==null:return
	var v=get_viewport().get_visible_rect().size
	var portrait=is_portrait()
	var touch=Controls.touch_enabled()
	place(hud_plate,Rect2(16,64 if portrait else 16,v.x-32 if portrait else minf(660,v.x-210),94 if portrait else 86))
	place(chapter,Rect2(28,22 if portrait else 24,v.x-220 if portrait else minf(625,v.x-242),36 if portrait else 22))
	chapter.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	place(hud,Rect2(28,74 if portrait else 47,v.x-56 if portrait else minf(625,v.x-242),74 if portrait else 50))
	place(pause_button,Rect2(v.x-88,12,72,68 if portrait else 64))
	party_bar.position=Vector2(16,170 if portrait else (152 if touch else v.y-70))
	for b in party_buttons:
		b.custom_minimum_size=Vector2(72,66) if portrait else Vector2(62,56)
		b.add_theme_constant_override("icon_max_width",43 if portrait else 35)
	place(resource_label,Rect2(16 if touch or portrait else 302,246 if portrait else (212 if touch else v.y-56),v.x-32 if portrait else 620,62))
	resource_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	place(toast,Rect2(24,338 if portrait else 108,v.x-48 if portrait else minf(720,v.x-48),75 if portrait else 44))
	var prompt_y=v.y-(320 if portrait else 187)
	place(prompt_plate,Rect2(16 if portrait else 210,prompt_y,v.x-32 if portrait else v.x-420,82 if portrait else 64))
	place(prompt,Rect2(28 if portrait else 225,prompt_y+8,v.x-56 if portrait else v.x-450,66 if portrait else 49))
	place(save_status,Rect2(24 if portrait else v.x-260,380 if portrait else 70,v.x-48 if portrait else 235,68))
	if is_instance_valid(modal):
		modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		modal.offset_left=16 if portrait else 60;modal.offset_right=-16 if portrait else -60
		modal.offset_top=76 if portrait else 38;modal.offset_bottom=-24 if portrait else -38
		if menu_kind=="title":
			modal.offset_left=16 if portrait else 40;modal.offset_top=64 if portrait else 66
			modal.offset_right=-16 if portrait else -v.x+472;modal.offset_bottom=-145 if portrait else -35
		elif menu_kind=="dialogue":
			modal.offset_top=maxf(80,v.y-(440 if portrait else (350 if State.prefs.large_text else 270)))
			modal.offset_bottom=-24
		elif menu_kind in ["pause","party","new"] and not portrait:modal.offset_left=180;modal.offset_right=-180
		resize_buttons(modal,68 if portrait or touch else 46)
	for i in title_friends.size():
		title_friends[i].position=Vector2(v.x/2-126+i*84,v.y-40) if portrait else Vector2(v.x-415+i*95,440)
		title_friends[i].scale=Vector2.ONE*(0.8 if portrait else 1.1)

func resize_buttons(node: Node,height: float) -> void:
	if node is Button:node.custom_minimum_size.y=height
	for child in node.get_children():resize_buttons(child,height)

func layout_snapshot() -> Dictionary:
	var heroes=[]
	for hero_button in party_buttons:
		var h=hero_button.get_global_rect();heroes.append([h.position.x,h.position.y,h.size.x,h.size.y])
	var rects={}
	for action in Controls.touch_rects(get_viewport().get_visible_rect().size):
		var r: Rect2=Controls.touch_rects(get_viewport().get_visible_rect().size)[action]
		rects[action]=[r.position.x,r.position.y,r.size.x,r.size.y]
	var v=get_viewport().get_visible_rect().size
	var r=modal.get_global_rect() if is_instance_valid(modal) else Rect2()
	var buttons=[]
	if is_instance_valid(modal):collect_buttons(modal,buttons)
	return {"buttons":buttons,"heroes":heroes,"pause":[pause_button.position.x,pause_button.position.y,pause_button.size.x,pause_button.size.y],"viewport":[v.x,v.y],"portrait":is_portrait(),"touch":Controls.touch_enabled(),"touch_rects":rects,"modal":[r.position.x,r.position.y,r.size.x,r.size.y],"player_screen":[game.player.get_global_transform_with_canvas().origin.x,game.player.get_global_transform_with_canvas().origin.y] if game.player else []}


func collect_buttons(node: Node,result: Array) -> void:
	if node is Button:
		var rect=node.get_global_rect()
		result.append({"text":node.text,"rect":[rect.position.x,rect.position.y,rect.size.x,rect.size.y]})
	for child in node.get_children():collect_buttons(child,result)


func tr_pair(pair: Array) -> String:return str(pair[0 if State.prefs.language=="tr" else 1])

func apply_preferences() -> void:
	var old_colors=[PlanetSkin.PAPER,PlanetSkin.GOLD,PlanetSkin.SAGE]
	PlanetSkin.configure(State.prefs)
	root.theme=PlanetSkin.theme()
	root.theme.default_font_size=22 if State.prefs.large_text else (20 if is_portrait() else 18)
	refresh_skin(root,old_colors)
	hud_plate.add_theme_stylebox_override("panel",PlanetSkin.box(PlanetSkin.INK,Color("587780"),0))
	prompt_plate.add_theme_stylebox_override("panel",PlanetSkin.box(PlanetSkin.INK,PlanetSkin.GOLD,10))
	hud.add_theme_color_override("font_color",PlanetSkin.PAPER)
	prompt.add_theme_color_override("font_color",PlanetSkin.PAPER)
	party_signature=""
	if OS.has_feature("web"):
		var appearance=JavaScriptBridge.get_interface("planetAppearance")
		if appearance!=null:appearance.apply(State.prefs.theme)
	arrange()
	hud.add_theme_font_size_override("font_size",24 if State.prefs.large_text else (20 if is_portrait() else 18))
	chapter.add_theme_font_size_override("font_size",16 if is_portrait() else 13)
	resource_label.add_theme_font_size_override("font_size",22 if State.prefs.large_text else (18 if is_portrait() else 14))
	pause_button.accessibility_name=State.text("Duraklat","Pause")
	game.audio.apply()
	touch_boxes.clear()
	for child in touch_layer.get_children():touch_layer.remove_child(child);child.queue_free()
	if Controls.touch_enabled():
		var rects=Controls.touch_rects(get_viewport().get_visible_rect().size)
		for action in rects:
			var box=Panel.new();box.position=rects[action].position;box.size=rects[action].size;box.mouse_filter=Control.MOUSE_FILTER_IGNORE
			box.accessibility_name=Controls.action_name(action)
			var st=StyleBoxFlat.new();st.bg_color=Color(0.09,0.23,0.27,0.72);st.set_border_width_all(2);st.border_color=Color("b9d0aa");box.add_theme_stylebox_override("panel",st)
			touch_layer.add_child(box);touch_boxes[action]=box
			var label=Label.new();label.text={"left":"◀","right":"▶","down":"↓","jump":"↑","ability":State.text("Güç","Skill"),"interact":State.text("Yap","Use")}[action];label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER;label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;box.add_child(label)

func _process(dt: float) -> void:
	theme_clock+=dt
	if theme_clock>1.0:
		theme_clock=0
		if State.prefs.theme=="system" and PlanetSkin.light==PlanetSkin.system_dark():apply_preferences()
	for action in touch_boxes:
		var pressed=Input.is_action_pressed(action)
		touch_boxes[action].modulate=Color(1,1,1,1) if pressed else Color(0.75,0.85,0.85,0.85)
	if toast_left>0:toast_left-=dt
	toast.visible=toast_left>0 and menu_kind==""
	hud.visible=menu_kind==""
	chapter.visible=menu_kind==""
	hud_plate.visible=menu_kind==""
	party_bar.visible=menu_kind==""
	resource_label.visible=menu_kind==""
	pause_button.visible=menu_kind==""
	prompt.visible=menu_kind==""
	save_status.visible=State.storage_error
	save_status.text=State.text("! Kayıt sorunu\nAyarlar → Yerel veriler","! Saving needs attention\nSettings → Local data")
	refresh_hints()
	if game.player==null:return
	game.publish_qa(dt)
	var title=tr_pair(game.level_data.title)
	var hero=State.text(["Aion","Melun Bilge Kurt","Kuzu","Baykuş Ömer"][State.active],["Aion","Wise Wolf","Lamb","Ömer the Owl"][State.active])
	chapter.text=(State.text("YAŞAM ALANI","SANCTUARY") if game.in_hub else State.text("PERDE ","ACT ")+str(int(game.level_data.act))+"  /  "+str(State.level+1).pad_zeros(2)+" · 10")+"   /   "+title
	hud.text=game.goal_text()
	var touch=Controls.touch_enabled()
	var skills=[["Çift zıplama · akış","Double jump · flow"],["Depar · ağır düzenek","Dash · heavy mechanisms"],["Takla · alçak geçit","Roll · low tunnel"],["Süzülüş · gözlem","Glide · observe"]]
	var party_hint=State.text("Portrelere dokun","Tap portraits") if touch else State.text("Takım [","Party [")+Controls.hint("party")+"]"
	var ability_hint="" if touch else "["+Controls.hint("ability")+"] "
	resource_label.text=hero+"  /  "+tr_pair(skills[State.active])+"\n"+party_hint+"  ·  "+ability_hint+("%.1f s"%game.player.cooldown if game.player.cooldown>0 else State.text("Yetenek hazır","Ability ready"))
	if State.active==3:resource_label.text+="  /  %.1f s"%game.player.glide_left
	var signature=str(State.active)+str(State.unlocked)
	if signature!=party_signature:
		party_signature=signature
		for i in 4:
			var button: Button=party_buttons[i];button.disabled=not i in State.unlocked;button.text=str(i+1) if not button.disabled else "?"
			button.accessibility_name=State.text(["Aion","Kurt","Kuzu","Ömer"][i],["Aion","Wolf","Lamb","Owl"][i])+" · "+tr_pair(skills[i])+(State.text(" · Henüz katılmadı"," · Not yet available") if button.disabled else "")
			if not button.disabled:
				button.icon=load("res://assets/derived/canonical-"+HeroVisual.HEROES[i]+"-0-0.png")
			else:button.icon=null
			button.add_theme_stylebox_override("normal",PlanetSkin.box((Color("b4cebc") if PlanetSkin.light else Color("385e63")) if State.active==i else PlanetSkin.PANEL,PlanetSkin.GOLD if State.active==i else Color("4e6c77"),7))
	var nearest=game.nearest_action()
	prompt.text=""
	if nearest and menu_kind=="":prompt.text="["+game.key_name("interact")+"] "+tr_pair(nearest.label)
	elif game.player.position.x>float(game.level_data.length)-180 and menu_kind=="":prompt.text="["+game.key_name("interact")+"] "+State.text("Çıkış","Exit")
	prompt_plate.visible=prompt.text!="" and menu_kind==""

func flash(tr_text: String,en_text: String) -> void:
	toast.text=State.text(tr_text,en_text);toast_left=4.5

func refresh_hints() -> void:
	var revision=Controls.input_method+str(State.prefs.language)+str(State.prefs.bindings)+str(State.prefs.gamepad_bindings)+menu_kind
	if revision==hint_revision:return
	hint_revision=revision
	if is_instance_valid(title_hint):
		title_hint.text=State.text("Hareket: ","Move: ")+Controls.hint("left")+" / "+Controls.hint("right")+"\n"+State.text("Zıpla: ","Jump: ")+Controls.hint("jump")+"  ·  "+State.text("Etkileşim: ","Interact: ")+Controls.hint("interact")
	if is_instance_valid(title_hint) and Controls.input_method=="touch":
		title_hint.text=State.text("Sol alttan yürü. Sağdan zıpla veya etkileş.\nPortreye dokunarak karakter seç.","Walk at the bottom left. Jump or interact on the right.\nTap a portrait to choose a hero.")
	if is_instance_valid(dialogue_next):
		dialogue_next.text=State.text("Devam   [","Continue   [")+Controls.menu_hint(true)+"]"
		dialogue_next.accessibility_name=dialogue_next.text
	if is_instance_valid(dialogue_skip):
		dialogue_skip.text=State.text("Geç [","Skip [")+Controls.menu_hint(false)+"]"
		dialogue_skip.accessibility_name=dialogue_skip.text

func open_panel(title: String,kind: String) -> void:
	close_panel(false)
	menu_kind=kind;get_tree().paused=true;dimmer.visible=kind!="title";Controls.release_all()
	if game.player:game.player.buffer=0;game.player.velocity=Vector2.ZERO
	modal=PanelContainer.new();modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);modal.offset_left=60;modal.offset_right=-60;modal.offset_top=38;modal.offset_bottom=-38
	if kind=="dialogue":modal.offset_top=get_viewport().get_visible_rect().size.y-(350 if State.prefs.large_text else 270);modal.offset_bottom=-24
	if kind=="title":modal.offset_left=40;modal.offset_top=66;modal.offset_right=-get_viewport().get_visible_rect().size.x+472;modal.offset_bottom=-35;modal.add_theme_stylebox_override("panel",PlanetSkin.box(PlanetSkin.INK,Color("5a7e83"),24))
	if kind in ["pause","party","new"]:modal.offset_left=180;modal.offset_right=-180
	root.add_child(modal)
	arrange()
	modal_stack=VBoxContainer.new();modal_stack.add_theme_constant_override("separation",10);modal.add_child(modal_stack)
	var scroll=ScrollContainer.new();scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;scroll.follow_focus=true;scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;modal_stack.add_child(scroll)
	footer_actions=VBoxContainer.new();footer_actions.add_theme_constant_override("separation",9);modal_stack.add_child(footer_actions)
	focus_assigned=false
	list=VBoxContainer.new();list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_theme_constant_override("separation",9);scroll.add_child(list)
	var label=Label.new();label.text=title;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.add_theme_font_size_override("font_size",26);label.add_theme_font_override("font",PlanetSkin.BOLD);list.add_child(label)

func paragraph(value: String) -> Label:
	var label=Label.new();label.text=value;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_child(label);return label

func button(value: String,callback: Callable,disabled: bool=false) -> Button:
	var b=Button.new();b.text=value;b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;b.custom_minimum_size.y=68 if is_portrait() or Controls.touch_enabled() else 46;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL;b.disabled=disabled;b.pressed.connect(callback)
	if menu_kind=="dialogue" or value in ["Geri","Back"]:footer_actions.add_child(b)
	else:list.add_child(b)
	b.accessibility_name=value
	if not disabled and not focus_assigned:b.call_deferred("grab_focus");focus_assigned=true
	return b

func close_panel(resume: bool=true) -> void:
	if is_instance_valid(modal):modal.queue_free()
	modal=null;menu_kind="";pending_binding="";dimmer.visible=false;Controls.release_all()
	for v in title_friends:
		if is_instance_valid(v):v.queue_free()
	title_friends.clear()
	if game.player:game.player.buffer=0
	if resume:get_tree().paused=false

func show_title() -> void:
	open_panel("SAVE THE\nPLANET", "title")
	var heading=list.get_child(0) as Label;heading.add_theme_font_size_override("font_size",42);heading.add_theme_color_override("font_color",PlanetSkin.PAPER)
	paragraph("AIONIA  /  FRAGARIA GAMES").add_theme_color_override("font_color",PlanetSkin.GOLD)
	paragraph(State.text("Bir dostun izinden.\nBirlikte açılan bir yol.","A trail to a friend.\nA way we open together."))
	for i in 4:
		var v=HeroVisual.new();v.hero=i;v.position=Vector2(545+i*95,440);v.scale=Vector2.ONE*1.1;root.add_child(v);title_friends.append(v)
	if State.completed.size()>0 or not State.flags.is_empty():
		var resume=button(State.text("Yolculuğa devam et","Continue the journey"),func():
			close_panel()
			if State.flags.get("story_complete",false):game.load_hub()
			else:game.load_level(State.level,true))
		PlanetSkin.primary(resume)
	var start=button(State.text("Yeni yolculuk","New journey"),func():
		if not State.flags.is_empty() or State.protected_future or State.unknown_save:show_new_confirm()
		else:start_new())
	if State.flags.is_empty():PlanetSkin.primary(start)
	button(State.text("Ayarlar ve kontroller","Settings and controls"),show_settings)
	title_hint=paragraph("");title_hint.add_theme_font_size_override("font_size",13);title_hint.add_theme_color_override("font_color",PlanetSkin.SAGE)
	var footer=paragraph("Fragaria Interactive  /  "+State.VERSION);footer.add_theme_font_size_override("font_size",12);footer.add_theme_color_override("font_color",PlanetSkin.SAGE)
	arrange()
	hint_revision=""
	if State.notice!="":paragraph(State.notice)

func show_new_confirm() -> void:
	open_panel(State.text("Yeni oyun?","New Game?"),"new")
	paragraph(State.text("Mevcut ilerleme değiştirilecek. Ayarların korunur.","This replaces current progress. Your settings remain."))
	button(State.text("Geri","Back"),show_title)
	button(State.text("Yeni oyunu başlat","Start New Game"),start_new)

func start_new() -> void:
	State.new_game();close_panel()
	if Controls.touch_enabled() and not State.prefs.touch_intro_seen:
		game.load_level(0,false,false);show_touch_intro()
	else:game.load_level(0,false)

func show_touch_intro() -> void:
	open_panel(State.text("İlk adımlar","First steps"),"touch_intro")
	paragraph(State.text("Sol alttaki oklarla yürü; ↓ ile platformdan aşağı in. Sağ alttan zıpla, Güç ile yeteneğini kullan. Aion havada bir kez daha zıplayabilir.","Walk with the bottom-left arrows; ↓ drops through a platform. Jump at the bottom right; Skill uses your ability. Aion can jump once more in the air."))
	paragraph(State.text("Yap: yakındaki nesneyle etkileşim. Portreler: karakter seçimi. Ⅱ: duraklatma ve ayarlar. Ekranı dikey veya yatay tutabilirsin.","Use interacts with a nearby object. Portraits select a hero. Ⅱ opens pause and settings. Play in portrait or landscape."))
	button(State.text("Anladım, başlayalım","Ready, let's begin"),finish_touch_intro)
	button(State.text("Öğretimi geç","Skip tutorial"),finish_touch_intro)

func finish_touch_intro() -> void:
	State.prefs.touch_intro_seen=true;State.save_preferences();close_panel()


func show_pause() -> void:
	if menu_kind=="title":return
	open_panel(State.text("Kısa bir mola","A moment to rest"),"pause")
	var resume=button(State.text("Devam","Resume"),func():close_panel())
	resume.reparent(modal_stack);modal_stack.move_child(resume,0)
	button(State.text("Kontrol noktasına dön","Retry checkpoint"),func():close_panel();game.player.retry())
	button(State.text("Takım","Party"),show_party)
	button(State.text("Ayarlar ve kontroller","Settings and controls"),show_settings)
	button(State.text("Ömer’in defteri / konuşma geçmişi","Ömer’s journal / dialogue history"),show_journal)
	if State.flags.get("a1l2.escape_ready",false):button(State.text("Yaşam alanına uğra","Visit sanctuary"),func():close_panel();game.load_hub())
	button(State.text("Bölümler","Chapters"),show_chapters)
	button(State.text("Kaydet ve ana menü","Save and title"),func():State.save_game();show_title())
	resume.call_deferred("grab_focus")

func show_party() -> void:
	open_panel(State.text("Dört arkadaş","Four friends"),"party")
	var names=[["Aion · çift zıplama / su akışı","Aion · double jump / water flow"],["Melun Bilge Kurt · depar / ağır kapak","Wise Wolf · dash / heavy hatches"],["Kuzu · takla / dar geçit","Lamb · roll / low tunnels"],["Baykuş Ömer · sınırlı süzülüş / kayıtlar","Ömer · limited glide / records"]]
	for i in 4:
		button(str(i+1)+" · "+tr_pair(names[i]),func():
			if game.player.switch_hero(i):close_panel(),not i in State.unlocked)
	paragraph(State.text("Havadaki haklar ve bekleme süresi takımca paylaşılır. Değiştirmek bunları yenilemez.","Air resources and cooldowns are shared. Switching never refreshes them."))
	button(State.text("Geri","Back"),func():close_panel())

func show_dialogue(pair: Array) -> void:
	var value=tr_pair(pair)
	State.history.append(pair)
	if State.history.size()>100:State.history.pop_front()
	State.save_game()
	dialogue_pages.clear()
	var page=""
	for word in value.split(" "):
		if page.length()+word.length()>255:
			dialogue_pages.append(page);page=""
		page+=(" " if page!="" else "")+word
	if page!="":dialogue_pages.append(page)
	show_dialogue_page()

func show_dialogue_page() -> void:
	if dialogue_pages.is_empty():close_panel();return
	var value: String=dialogue_pages.pop_front()
	var colon=value.find(":")
	var speaker=value.substr(0,colon) if colon>=0 and colon<50 else State.text("Yol arkadaşları","Along the way")
	open_panel(speaker,"dialogue")
	list.get_child(0).add_theme_color_override("font_color",PlanetSkin.GOLD)
	var speaker_id=-1
	for i in 4:
		if ["Aion","Kurt","Kuzu","Ömer"][i] in speaker:speaker_id=i
	if speaker_id>=0:
		var name_label=list.get_child(0);var row=HBoxContainer.new();row.add_theme_constant_override("separation",12);list.add_child(row);list.move_child(row,0);name_label.reparent(row)
		var portrait=TextureRect.new();portrait.texture=load("res://assets/derived/canonical-"+HeroVisual.HEROES[speaker_id]+"-0-0.png");portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;portrait.custom_minimum_size=Vector2(60,48);row.add_child(portrait);row.move_child(portrait,0)
	paragraph(value.substr(colon+1).strip_edges() if colon>=0 and colon<50 else value)
	var next=button(State.text("Devam   [Enter]","Continue   [Enter]"),func():
		if dialogue_pages.is_empty():close_panel()
		else:show_dialogue_page())
	PlanetSkin.primary(next)
	dialogue_next=next
	if not dialogue_pages.is_empty():
		var row=HBoxContainer.new();row.add_theme_constant_override("separation",12);footer_actions.add_child(row);next.reparent(row)
		var skip=Button.new();skip.text=State.text("Geç [Esc]","Skip [Esc]");skip.custom_minimum_size=Vector2(150,68 if is_portrait() or Controls.touch_enabled() else 46);skip.pressed.connect(func():close_panel());row.add_child(skip);next.call_deferred("grab_focus")
		dialogue_skip=skip
	hint_revision=""

func show_settings() -> void:
	if menu_kind in ["title","pause"]:settings_origin=menu_kind
	open_panel(State.text("Ayarlar ve kontroller","Settings and controls"),"settings")
	button(State.text("Dil: Türkçe / English","Language: English / Türkçe"),func():State.prefs.language="en" if State.prefs.language=="tr" else "tr";State.save_preferences();apply_preferences();show_settings())
	button(State.text("Mod: ","Mode: ")+State.text("Hikâye" if State.prefs.story else "Standart","Story" if State.prefs.story else "Standard"),func():State.prefs.story=not State.prefs.story;State.save_preferences();show_settings())
	button(State.text("Büyük metin: ","Large text: ")+State.text("Açık" if State.prefs.large_text else "Kapalı","On" if State.prefs.large_text else "Off"),func():State.prefs.large_text=not State.prefs.large_text;State.save_preferences();apply_preferences();show_settings())
	button(State.text("Azaltılmış hareket ve efekt: ","Reduced motion and effects: ")+State.text("Açık" if State.prefs.reduced_effects else "Kapalı","On" if State.prefs.reduced_effects else "Off"),func():State.prefs.reduced_effects=not State.prefs.reduced_effects;State.save_preferences();apply_preferences();show_settings())
	button(State.text("Dokunmatik kontroller: ","Touch controls: ")+State.text("Açık" if State.prefs.touch else "Kapalı","On" if State.prefs.touch else "Off"),func():State.prefs.touch=not State.prefs.touch;State.save_preferences();apply_preferences();show_settings())
	var themes={"dark":State.text("Koyu","Dark"),"light":State.text("Açık","Light"),"system":State.text("Sistem","System")}
	button(State.text("Tema: ","Theme: ")+themes[State.prefs.theme],func():
		var modes=["dark","light","system"];State.prefs.theme=modes[(modes.find(State.prefs.theme)+1)%3];State.save_preferences();apply_preferences();show_settings())
	button(State.text("Yazı tipi: ","Font: ")+State.text("Sistem" if State.prefs.font=="system" else "Yerleşik","System" if State.prefs.font=="system" else "Bundled"),func():
		State.prefs.font="bundled" if State.prefs.font=="system" else "system";State.save_preferences();apply_preferences();show_settings())
	if OS.has_feature("web"):
		paragraph(State.text("Tarayıcı cihaz yazı tipini kullanamıyorsa okunabilir yedek yazı gösterilir.","If the browser cannot use your device font, a readable fallback is shown."))
	for key in ["music","sfx"]:
		var row=HBoxContainer.new();list.add_child(row)
		var label=Label.new();label.text=State.text("Müzik" if key=="music" else "Efekt","Music" if key=="music" else "Effects");label.custom_minimum_size.x=130;row.add_child(label)
		var slider=HSlider.new();slider.min_value=0;slider.max_value=1;slider.step=0.05;slider.value=float(State.prefs[key]);slider.size_flags_horizontal=Control.SIZE_EXPAND_FILL;slider.custom_minimum_size.y=44;slider.tooltip_text=label.text;row.add_child(slider)
		slider.accessibility_name=label.text
		slider.value_changed.connect(func(value):State.prefs[key]=value;game.audio.apply();State.save_preferences())
	button(State.text("Tam ekran / Pencere","Fullscreen / Window"),func():DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN))
	button(State.text("Klavye tuşlarını düzenle","Keyboard bindings"),func():show_bindings("keyboard"))
	button(State.text("Gamepad düğmelerini düzenle","Gamepad bindings"),func():show_bindings("gamepad"))
	var row=HBoxContainer.new();list.add_child(row)
	var label=Label.new();label.text=State.text("Analog eşik","Stick deadzone");label.custom_minimum_size.x=180;row.add_child(label)
	var deadzone=HSlider.new();deadzone.min_value=0.15;deadzone.max_value=0.5;deadzone.step=0.05;deadzone.value=State.prefs.deadzone;deadzone.size_flags_horizontal=Control.SIZE_EXPAND_FILL;deadzone.custom_minimum_size.y=44;deadzone.tooltip_text=State.text("Küçük çubuk hareketlerini yok say","Ignore small stick movements");row.add_child(deadzone)
	deadzone.accessibility_name=label.text
	deadzone.value_changed.connect(func(value):State.prefs.deadzone=value;Controls.apply_deadzone();State.save_preferences())
	button(State.text("Nasıl oynanır?","How to play"),show_help)
	button(State.text("Yerel veriler ve mahremiyet","Local data and privacy"),show_privacy)
	button(State.text("Geri","Back"),settings_back)

func settings_back() -> void:
	if settings_origin=="title":show_title()
	else:show_pause()

func show_help() -> void:
	open_panel(State.text("Nasıl oynanır?","How to play"),"help")
	paragraph(State.text("Sol üstteki hedefi izle. Güvenli yolu aç; hayvanın kendi hareketini bekle. Yaklaşınca görünen etkileşim tuşunu kullan. Hikâye modunda hata yapmak ilerlemeyi silmez.","Follow the goal at the top left. Open a safe path and let the animal move on its own. Use the interaction hint when nearby. In Story mode, mistakes do not erase progress."))
	for action in ["left","right","jump","ability","interact","party","pause","journal","hero_prev","hero_next"]:
		paragraph(Controls.action_name(action)+"  /  "+Controls.hint(action,"keyboard")+"  /  "+Controls.hint(action,"gamepad"))
	paragraph(State.text("Aion: çift zıplama. Kurt: depar. Kuzu: takla. Ömer: zıplamayı basılı tutarak sınırlı süzülme. Karakter değiştirmek havadaki hakları yenilemez. Dokunmatikte alt düğmeler hareket/eylemler, portreler karakter seçimidir. Cihazının otomatik döndürmesini açarak iki ekran yönünü de kullanabilirsin. Bu sürüm titreşim göndermez.","Aion: double jump. Wolf: dash. Lamb: roll. Owl: hold jump for limited glide. Switching never restores air resources. On touchscreens, use the bottom controls and tap portraits to switch heroes. Enable device auto-rotation to use both orientations. This version sends no vibration."))
	button(State.text("Geri","Back"),show_settings)

func show_bindings(device: String="keyboard") -> void:
	binding_device=device
	open_panel(State.text("Gamepad düğmeleri","Gamepad bindings") if device=="gamepad" else State.text("Klavye tuşları","Keyboard bindings"),"bindings")
	var actions=Controls.REMAPPABLE_PAD if device=="gamepad" else Controls.KEYS.keys()
	for action in actions:
		if device=="keyboard" and action in ["hero_prev","hero_next"]:continue
		button(Controls.action_name(action)+" : "+Controls.hint(action,device),func():
			pending_binding=action
			paragraph(State.text("Yeni düğmeye bas. Start veya Esc iptal eder.","Press a new button. Start or Esc cancels.") if device=="gamepad" else State.text("Yeni tuşa bas. Esc iptal eder.","Press a new key. Esc cancels.")))
	button(State.text("Varsayılanları geri getir","Restore defaults"),func():
		if device=="gamepad":Controls.reset_gamepad()
		else:Controls.reset_keyboard()
		show_bindings(device))
	button(State.text("Geri","Back"),show_settings)

func show_privacy() -> void:
	open_panel(State.text("Yerel veriler ve mahremiyet","Local data and privacy"),"privacy")
	paragraph(State.text("Bu oyun hesap, reklam, analiz veya oyun içi takip kullanmaz. İlerleme, ayarlar ve oyunun kendi konuşma geçmişi bu cihazda/tarayıcıda saklanır. Başka cihaza otomatik aktarılmaz. Silme sonrası, eski tarayıcı kaydının geri dönmesini önleyen ilerlemesiz bir işaret kalabilir.","This game uses no accounts, ads, analytics or in-game tracking. Progress, settings and the game's authored dialogue history are stored on this device/browser. They do not sync to other devices. After deletion, a marker without progress may remain to prevent old browser data returning."))
	paragraph(State.text("Web sunucusu dosya istekleri için IP ve tarayıcı gibi erişim verilerini işleyebilir. Tarayıcı önbelleği ve sunucu erişim kayıtları aşağıdaki işlemle silinmez. Ortak cihazda işin bittiğinde yerel oyun verilerini silebilirsin.","The web host may process access data such as IP and browser information for file requests. Browser caches and server logs are not removed by the action below. On a shared device, you can delete the local game data when finished."))
	if State.notice!="":paragraph(State.notice)
	if State.storage_error and not State.storage_paused:
		button(State.text("Kaydı yeniden dene","Retry saving"),func():State.save_game();show_privacy())
	button(State.text("Bu oyunun yerel verilerini sil…","Delete this game's local data…"),show_erase_confirm)
	button(State.text("Geri","Back"),show_settings)

func show_erase_confirm() -> void:
	open_panel(State.text("Yerel oyun verileri silinsin mi?","Delete local game data?"),"erase")
	paragraph(State.text("İlerleme, ayarlar, konuşma geçmişi ve bu oyunun kayıt yedekleri silinecek. Bu işlem geri alınamaz. Başka uygulamaların verilerine dokunulmaz.","Progress, settings, dialogue history and this game's save backups will be deleted. This cannot be undone. Data belonging to other apps is preserved."))
	button(State.text("İptal","Cancel"),show_privacy)
	var erase=button(State.text("Yerel verileri sil","Delete local data"),func():
		if State.erase_local_data():
			Controls.reset_keyboard(false);Controls.reset_gamepad(false);Controls.apply_deadzone()
			game.load_level(0,false,false)
			show_title()
		else:show_privacy())
	erase.add_theme_stylebox_override("normal",PlanetSkin.box(Color("703a48"),PlanetSkin.GOLD,11))
	for key in ["font_color","font_hover_color","font_focus_color"]:erase.add_theme_color_override(key,Color.WHITE)

func show_chapters() -> void:
	open_panel(State.text("Beş perde · on bölüm","Five acts · ten chapters"),"chapters")
	for i in game.LEVELS.data.size():
		var d=game.LEVELS.data[i]
		var allowed=i==0 or (i-1) in State.completed or State.flags.get("story_complete",false)
		button(str(i+1)+" · "+tr_pair(d.title)+(" ✓" if i in State.completed else ""),func():close_panel();game.load_level(i,true),not allowed)
	button(State.text("Geri","Back"),show_pause)

func binding_result(ok: bool) -> void:
	show_bindings(binding_device)
	if not ok:
		var warning=paragraph(Controls.binding_notice)
		warning.add_theme_color_override("font_color",PlanetSkin.GOLD)
		list.move_child(warning,1)

func show_journal() -> void:
	open_panel(State.text("Ömer’in defteri","Ömer’s journal"),"journal")
	paragraph(State.text("Hayvanlar puan, para veya işçi değildir. Güvenli koşullar oluşturmak onlara yaklaşma zorunluluğu getirmez. Yaban hayvanları habitatında; evcilleştirilmiş bireyler uygun bakım alanında kalır. İnsanların vegan tercihleri diğer türlerin biyolojisini tanımlamaz.","Animals are not points, money or workers. Creating safe conditions does not require them to approach us. Wildlife stays in its habitat; domesticated individuals receive appropriate care. Human vegan choices do not define other species’ biology."))
	paragraph(State.text("Aion’un hareketleri fantastiktir. Bir yetenek gerçek kirli suyu içilebilir yapmaz. Nehirdeki model: kaynağı durdur → akışı düzenle → arıt → bekle → kontrol et.","Aion’s abilities are fantasy. No ability makes real polluted water drinkable. The river model is: stop source → divert → treat → wait → inspect."))
	paragraph(State.text("Tema bağlantıları: SDG 6.3/6.6, 14.1/14.2, 15.1/15.5, 12.2/12.5/12.8, 13.3 ve 4.7. Bunlar BM onayı değildir. Games for Change üyeliği veya sertifikası iddia edilmez.","Thematic links: SDG 6.3/6.6, 14.1/14.2, 15.1/15.5, 12.2/12.5/12.8, 13.3 and 4.7. No UN endorsement or Games for Change membership/certification is claimed."))
	paragraph("https://sdgs.un.org/goals\nFoundations of Game-Based Learning (Plass, Homer & Kinzer, 2015)\nhttps://files.eric.ed.gov/fulltext/EJ1090277.pdf")
	paragraph(State.text("Yeşil Vitrin kayıtları kurgu: kaynak, 2026 tarihleri, saat birimi ve yalnız doğu hattını kapsama sınırı sahada görünür. Tüm tesis hakkında yeterli bilgi yok sonucu ilerlemeyi açar.","Green Showcase records are fictional: source, 2026 dates, hours and the eastern-line scope appear in the world. Insufficient evidence for the whole plant is a valid progression result."))
	paragraph(State.text("İsteğe bağlı ustalık: üst rotaları keşfet ve makinelerin durduğu aralıkları kullan. Hikâye sonu bu hedeflere bağlı değildir.","Optional mastery: explore upper routes and use stopped-machine intervals. The story ending does not depend on these goals."))
	for pair in State.history:paragraph(tr_pair(pair))
	button(State.text("Geri","Back"),show_pause)

func _input(event: InputEvent) -> void:
	# Native Button mouse emulation follows the first finger on Web. Handle
	# gameplay portraits/pause explicitly so a second finger works while moving.
	if event is InputEventScreenTouch and event.pressed and menu_kind=="":
		if pause_button.get_global_rect().has_point(event.position):
			show_pause();get_viewport().set_input_as_handled();return
		for i in party_buttons.size():
			if not party_buttons[i].disabled and party_buttons[i].get_global_rect().has_point(event.position):
				game.player.switch_hero(i);get_viewport().set_input_as_handled();return
	if pending_binding!="":
		if event is InputEventKey and event.pressed and not event.echo:
			var ok=true
			if event.physical_keycode!=KEY_ESCAPE and binding_device=="keyboard":ok=Controls.rebind(pending_binding,event.physical_keycode)
			elif event.physical_keycode!=KEY_ESCAPE:return
			pending_binding="";get_viewport().set_input_as_handled();binding_result(ok)
			return
		if event is InputEventJoypadButton and event.pressed and binding_device=="gamepad":
			var ok=true
			if event.button_index!=JOY_BUTTON_START:ok=Controls.rebind_gamepad(pending_binding,event.button_index)
			pending_binding="";get_viewport().set_input_as_handled();binding_result(ok)
			return
		if event is InputEventJoypadMotion:get_viewport().set_input_as_handled();return
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode==KEY_F1:
		if menu_kind in ["title",""]:settings_origin="title" if menu_kind=="title" else "pause"
		show_help();get_viewport().set_input_as_handled();return
	if menu_kind!="" and (event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel")):
		get_viewport().set_input_as_handled()
		if menu_kind=="title":return
		if menu_kind=="new":show_title();return
		if menu_kind=="touch_intro":finish_touch_intro();return
		if event is InputEventJoypadButton and event.button_index==JOY_BUTTON_START:
			if settings_origin=="title" and menu_kind in ["settings","bindings","privacy","help","erase"]:
				show_title();return
			close_panel();return
		if menu_kind=="settings":settings_back();return
		if menu_kind in ["bindings","help","privacy"]:show_settings();return
		if menu_kind=="erase":show_privacy();return
		close_panel();return
	if menu_kind=="dialogue" and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		if dialogue_pages.is_empty():close_panel()
		else:show_dialogue_page()
