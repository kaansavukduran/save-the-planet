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
var menu_kind=""
var pending_binding=""
var toast_left=0.0
var title_friends: Array = []

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	var theme=Theme.new();theme.default_font_size=17;theme.default_font=preload("res://assets/fonts/DejaVuSans.ttf")
	var panel=StyleBoxFlat.new();panel.bg_color=Color("173b43");panel.border_color=Color("b9d0aa");panel.set_border_width_all(2);panel.set_content_margin_all(18)
	theme.set_stylebox("panel","PanelContainer",panel)
	var normal=StyleBoxFlat.new();normal.bg_color=Color("315d61");normal.set_content_margin_all(10);normal.border_color=Color("87b79b");normal.set_border_width_all(1)
	theme.set_stylebox("normal","Button",normal)
	var focus=normal.duplicate();focus.border_color=Color("ffe2a1");focus.set_border_width_all(3)
	theme.set_stylebox("focus","Button",focus);theme.set_stylebox("hover","Button",focus)
	root=Control.new();root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);root.mouse_filter=Control.MOUSE_FILTER_IGNORE;root.theme=theme;add_child(root)
	get_viewport().size_changed.connect(apply_preferences)
	hud=Label.new();hud.position=Vector2(20,12);hud.size=Vector2(800,90);hud.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;hud.add_theme_color_override("font_color",Color("f6efcc"));hud.add_theme_color_override("font_shadow_color",Color("173b43"));hud.add_theme_constant_override("shadow_offset_x",2);hud.add_theme_constant_override("shadow_offset_y",2);root.add_child(hud)
	var menu=Button.new();menu.text="|||";menu.position=Vector2(890,12);menu.size=Vector2(48,44);menu.pressed.connect(show_pause);root.add_child(menu)
	menu.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT);menu.offset_left=-68;menu.offset_right=-20;menu.offset_top=12;menu.offset_bottom=56
	prompt=Label.new();prompt.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;prompt.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;prompt.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE);prompt.offset_top=-178;prompt.offset_bottom=-139;prompt.offset_left=160;prompt.offset_right=-160
	prompt.add_theme_color_override("font_color",Color("fff0b6"));prompt.add_theme_color_override("font_shadow_color",Color("173b43"));prompt.add_theme_constant_override("shadow_offset_x",2);prompt.add_theme_constant_override("shadow_offset_y",2);root.add_child(prompt)
	toast=Label.new();toast.position=Vector2(20,83);toast.size=Vector2(820,70);toast.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;toast.add_theme_color_override("font_color",Color("fff3c7"));toast.add_theme_color_override("font_shadow_color",Color("173b43"));toast.add_theme_constant_override("shadow_offset_x",2);toast.add_theme_constant_override("shadow_offset_y",2);root.add_child(toast)
	touch_layer=Control.new();touch_layer.mouse_filter=Control.MOUSE_FILTER_IGNORE;root.add_child(touch_layer)
	apply_preferences()

func tr_pair(pair: Array) -> String:return str(pair[0 if State.prefs.language=="tr" else 1])

func apply_preferences() -> void:
	root.theme.default_font_size=22 if State.prefs.large_text else 18
	game.audio.apply()
	for child in touch_layer.get_children():child.queue_free()
	if OS.has_feature("mobile") or State.prefs.touch:
		var rects=Controls.touch_rects(get_viewport().get_visible_rect().size)
		for action in rects:
			var box=Panel.new();box.position=rects[action].position;box.size=rects[action].size;box.mouse_filter=Control.MOUSE_FILTER_IGNORE
			var st=StyleBoxFlat.new();st.bg_color=Color(0.09,0.23,0.27,0.72);st.set_border_width_all(2);st.border_color=Color("b9d0aa");box.add_theme_stylebox_override("panel",st)
			touch_layer.add_child(box)
			var label=Label.new();label.text={"left":"◀","right":"▶","jump":"↑","ability":"J","interact":"E"}[action];label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER;label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;box.add_child(label)

func _process(dt: float) -> void:
	if toast_left>0:toast_left-=dt
	toast.visible=toast_left>0 and menu_kind==""
	hud.visible=menu_kind==""
	prompt.visible=menu_kind==""
	if game.player==null:return
	game.publish_qa(dt)
	var title=tr_pair(game.level_data.title)
	var hero=State.text(["Aion","Melun Bilge Kurt","Kuzu","Baykuş Ömer"][State.active],["Aion","Wise Wolf","Lamb","Ömer the Owl"][State.active])
	hud.text=("AIONIA / FRAGARIA INTERACTIVE\n" if menu_kind=="title" else "")+title+"  ·  "+hero+"\n"+State.text("Amaç: ","Goal: ")+game.goal_text()
	if State.active==3:hud.text+="  ·  "+State.text("Süzülüş ","Glide ")+"%.1fs"%game.player.glide_left
	hud.add_theme_font_size_override("font_size",18 if not State.prefs.large_text else 21)
	var nearest=game.nearest_action()
	prompt.text=""
	if nearest and menu_kind=="":prompt.text="["+game.key_name("interact")+"] "+tr_pair(nearest.label)
	elif game.player.position.x>float(game.level_data.length)-180 and menu_kind=="":prompt.text="["+game.key_name("interact")+"] "+State.text("Çıkış","Exit")

func flash(tr_text: String,en_text: String) -> void:
	toast.text=State.text(tr_text,en_text);toast_left=4.5

func open_panel(title: String,kind: String) -> void:
	close_panel(false)
	menu_kind=kind;get_tree().paused=true;Controls.release_all()
	if game.player:game.player.buffer=0;game.player.velocity=Vector2.ZERO
	modal=PanelContainer.new();modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);modal.offset_left=60;modal.offset_right=-60;modal.offset_top=38;modal.offset_bottom=-38
	if kind=="dialogue":modal.offset_top=get_viewport().get_visible_rect().size.y-240;modal.offset_bottom=-24
	if kind=="title":modal.offset_left=42;modal.offset_top=85;modal.offset_right=-get_viewport().get_visible_rect().size.x+490;modal.offset_bottom=-45
	root.add_child(modal)
	var scroll=ScrollContainer.new();scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;modal.add_child(scroll)
	list=VBoxContainer.new();list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_theme_constant_override("separation",9);scroll.add_child(list)
	var label=Label.new();label.text=title;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.add_theme_font_size_override("font_size",26);list.add_child(label)

func paragraph(value: String) -> Label:
	var label=Label.new();label.text=value;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_child(label);return label

func button(value: String,callback: Callable,disabled: bool=false) -> Button:
	var b=Button.new();b.text=value;b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;b.custom_minimum_size.y=42;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL;b.disabled=disabled;b.pressed.connect(callback);list.add_child(b)
	if not disabled and list.get_children().filter(func(c):return c is Button and not c.disabled).size()==1:b.call_deferred("grab_focus")
	return b

func close_panel(resume: bool=true) -> void:
	if is_instance_valid(modal):modal.queue_free()
	modal=null;menu_kind="";pending_binding="";Controls.release_all()
	for v in title_friends:
		if is_instance_valid(v):v.queue_free()
	title_friends.clear()
	if game.player:game.player.buffer=0
	if resume:get_tree().paused=false

func show_title() -> void:
	open_panel("SAVE THE PLANET", "title")
	for i in 4:
		var v=HeroVisual.new();v.hero=i;v.position=Vector2(560+(i%2)*170,270+(i/2)*135);v.scale=Vector2.ONE*1.3;root.add_child(v);title_friends.append(v)
	paragraph("FRAGARIA INTERACTIVE · AIONIA\n"+State.text("Bir vadinin yollarını birlikte aç. Hayvanların kendi yaşamları var; onlara güvenli koşullar oluştur.","Open a valley’s paths together. Animals have lives of their own; help create safe conditions."))
	if State.completed.size()>0 or not State.flags.is_empty():button(State.text("Kayıttan devam","Continue"),func():
			close_panel()
			if State.flags.get("story_complete",false):game.load_hub()
			else:game.load_level(State.level,true))
	button(State.text("Yeni oyun","New Game"),func():
		if not State.flags.is_empty():show_new_confirm()
		else:start_new())
	button(State.text("Ayarlar ve kontroller","Settings and controls"),show_settings)
	paragraph(State.text("A/D: yürü · Space: zıpla
J: yetenek · E: etkileşim\n1–4: karakter · Q: takım menüsü · Esc: duraklat · Tab: defter","A/D: move · Space: jump
J: ability · E: interact\n1–4: character · Q: party · Esc: pause · Tab: journal"))
	if State.notice!="":paragraph(State.notice)

func show_new_confirm() -> void:
	open_panel(State.text("Yeni oyun?","New Game?"),"new")
	paragraph(State.text("Mevcut ilerleme değiştirilecek. Ayarların korunur.","This replaces current progress. Your settings remain."))
	button(State.text("Geri","Back"),show_title)
	button(State.text("Yeni oyunu başlat","Start New Game"),start_new)

func start_new() -> void:
	State.new_game();close_panel();game.load_level(0,false)

func show_pause() -> void:
	if menu_kind=="title":return
	open_panel(State.text("Kısa bir mola","A moment to rest"),"pause")
	button(State.text("Devam","Resume"),func():close_panel())
	button(State.text("Kontrol noktasına dön","Retry checkpoint"),func():close_panel();game.player.retry())
	button(State.text("Takım","Party"),show_party)
	button(State.text("Ayarlar ve kontroller","Settings and controls"),show_settings)
	button(State.text("Ömer’in defteri / konuşma geçmişi","Ömer’s journal / dialogue history"),show_journal)
	if State.flags.get("a1l2.escape_ready",false):button(State.text("Yaşam alanına uğra","Visit sanctuary"),func():close_panel();game.load_hub())
	button(State.text("Bölümler","Chapters"),show_chapters)
	button(State.text("Kaydet ve ana menü","Save and title"),func():State.save_game();show_title())

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
	State.history.append(pair);if State.history.size()>100:State.history.pop_front()
	State.save_game()
	open_panel(State.text("Yol arkadaşları","Along the way"),"dialogue")
	paragraph(value)
	button(State.text("Devam / Geç","Continue / Skip"),func():close_panel())

func show_settings() -> void:
	open_panel(State.text("Ayarlar ve kontroller","Settings and controls"),"settings")
	button("Türkçe / English",func():State.prefs.language="en" if State.prefs.language=="tr" else "tr";State.save_game();show_settings())
	button(State.text("Mod: ","Mode: ")+State.text("Hikâye" if State.prefs.story else "Standart","Story" if State.prefs.story else "Standard"),func():State.prefs.story=not State.prefs.story;State.save_game();show_settings())
	button(State.text("Büyük metin: ","Large text: ")+State.text("Açık" if State.prefs.large_text else "Kapalı","On" if State.prefs.large_text else "Off"),func():State.prefs.large_text=not State.prefs.large_text;State.save_game();apply_preferences();show_settings())
	button(State.text("Azaltılmış efekt: ","Reduced effects: ")+State.text("Açık" if State.prefs.reduced_effects else "Kapalı","On" if State.prefs.reduced_effects else "Off"),func():State.prefs.reduced_effects=not State.prefs.reduced_effects;State.save_game();show_settings())
	button(State.text("Dokunmatik kontroller: ","Touch controls: ")+State.text("Açık" if State.prefs.touch else "Kapalı","On" if State.prefs.touch else "Off"),func():State.prefs.touch=not State.prefs.touch;State.save_game();apply_preferences();show_settings())
	for key in ["music","sfx"]:
		var row=HBoxContainer.new();list.add_child(row)
		var label=Label.new();label.text=State.text("Müzik" if key=="music" else "Efekt","Music" if key=="music" else "Effects");label.custom_minimum_size.x=130;row.add_child(label)
		var slider=HSlider.new();slider.min_value=0;slider.max_value=1;slider.step=0.05;slider.value=float(State.prefs[key]);slider.size_flags_horizontal=Control.SIZE_EXPAND_FILL;slider.custom_minimum_size.y=38;row.add_child(slider)
		slider.value_changed.connect(func(v):State.prefs[key]=v;game.audio.apply();State.save_game())
	button(State.text("Tam ekran / Pencere","Fullscreen / Window"),func():DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN))
	button(State.text("Tuşları yeniden ata","Rebind keys"),show_bindings)
	button(State.text("Geri","Back"),func():
		if State.flags.is_empty() and State.completed.is_empty():show_title()
		else:show_pause())

func show_bindings() -> void:
	open_panel(State.text("Klavye eşlemesi","Keyboard bindings"),"bindings")
	for action in Controls.KEYS:
		button(action+" : "+game.key_name(action),func():pending_binding=action;paragraph(State.text("Yeni tuşa bas. Esc iptal eder.","Press a new key. Esc cancels.")))
	button(State.text("Geri","Back"),show_settings)

func show_chapters() -> void:
	open_panel(State.text("Beş perde · on bölüm","Five acts · ten chapters"),"chapters")
	for i in game.LEVELS.data.size():
		var d=game.LEVELS.data[i]
		var allowed=i==0 or (i-1) in State.completed or State.flags.get("story_complete",false)
		button(str(i+1)+" · "+tr_pair(d.title)+(" ✓" if i in State.completed else ""),func():close_panel();game.load_level(i,true),not allowed)
	button(State.text("Geri","Back"),show_pause)

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
	if pending_binding!="" and event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode!=KEY_ESCAPE:Controls.rebind(pending_binding,event.physical_keycode)
		pending_binding="";get_viewport().set_input_as_handled();show_bindings();return
	if menu_kind!="" and event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		if menu_kind=="title":return
		close_panel();return
	if menu_kind=="dialogue" and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled();close_panel()
