extends Node2D
const LEVELS=preload("res://data/levels.json")
var world: PlanetWorld
var player: PlanetPlayer
var ui: PlanetUI
var audio: PlanetAudio
var level_data: Dictionary = {}
var in_hub=false
var last_cp=-1
var play_seconds=0.0
var attempts=0
var qa_clock=0.0

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_PAUSABLE
	audio=PlanetAudio.new();add_child(audio)
	ui=PlanetUI.new();ui.game=self;add_child(ui)
	load_level(State.level,true,false)
	ui.show_title()

func key_name(action: String) -> String:
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:return OS.get_keycode_string(e.physical_keycode)
	return action

func clear_scene() -> void:
	if is_instance_valid(world):remove_child(world);world.queue_free()
	if is_instance_valid(player):remove_child(player);player.queue_free()

func install_scene(data: Dictionary,spawn: Vector2) -> void:
	clear_scene();level_data=data;last_cp=-1
	world=PlanetWorld.new();add_child(world);world.setup(level_data)
	world.animal_arrived.connect(func():audio.cue();ui.flash("Güvenli koşullar hazır; kendi yolunu seçti.","Conditions are safe; the animal chose its own path."))
	player=PlanetPlayer.new();add_child(player);player.position=spawn;player.spawn=spawn
	player.used_ability.connect(func():
		audio.cue();interact(true))
	player.feedback.connect(ui.flash)
	player.retried.connect(func():attempts+=1;ui.flash("Yakındaki güvenli noktadasın. Dünya değişiklikleri korunur.","Back at a safe checkpoint. World changes remain."))
	var cam=PlanetCamera.new();cam.name="Camera2D";cam.position=Vector2(135,-170);cam.position_smoothing_enabled=true;cam.position_smoothing_speed=8;cam.limit_left=0;cam.limit_right=int(data.length);cam.limit_top=0;cam.limit_bottom=540;player.add_child(cam);cam.reset_smoothing()
	ui.apply_preferences()

func load_level(index: int,continuing: bool=true,dialogue: bool=true) -> void:
	in_hub=false;State.level=clampi(index,0,9)
	var data: Dictionary=LEVELS.data[State.level]
	var spawn=Vector2(100,440)
	if continuing and State.checkpoints.has(data.id):
		var cp=State.checkpoints[data.id]
		if float(cp[0]) in data.checkpoints and absf(float(cp[1])-440)<1:spawn=Vector2(cp[0],cp[1])
		else:State.notice="Güvenli başlangıç noktası kullanıldı. / Safe start restored."
	install_scene(data,spawn);State.save_game()
	if dialogue:ui.show_dialogue(data.intro)

func load_hub() -> void:
	in_hub=true
	var done=State.flags.get("story_complete",false)
	var actions=[
		{"id":"hub.duru","x":480,"y":440,"label":["Duru’ya alan bırakıp gözlemle","Watch Duru from a respectful distance"],"heroes":[],"requires":[],"kind":"record","reply":["Duru isterse yaklaşır, isterse dinlenir. Bakım karşılığında çalışmak veya seni izlemek zorunda değil.","Duru can approach or rest. Care does not require her to work or follow you."]},
		{"id":"hub.habitats","x":1050,"y":440,"label":["Yaşam alanlarının izlerini incele","Check the habitat notes"],"heroes":[],"requires":[],"kind":"record","reply":["Ormandaki geçit ve yuva yerinde kaldı. Yaban hayvanlarını bu bahçeye taşımadık. Kıyıdaki bireyin bakımı Aslı’nın gözetiminde sürüyor.","The forest passage and nest remain in place. Wildlife was not brought into this garden. Aslı continues supervising care at the coast."]},
		{"id":"hub.meal","x":1520,"y":440,"label":["Ortak sofraya uğra","Visit the shared table"],"heroes":[],"requires":[],"kind":"meal","reply":["Emre: Burada yemek bir ödül veya hayvanların emeği karşılığında verilen hak değil. Final hazırlığında mercimekli seçeneği birlikte uyguladık.","Emre: A meal here is not a reward or payment for animals’ labour. We prepared a lentil option together for the finale."]}]
	var data={"id":"sanctuary","title":["Özgür Yaşam Alanı"+(" · Birlikte açılan gelecek" if done else ""),"Sanctuary"+(" · An open future" if done else "")],"biome":"meadow","length":2200,"ground":[[0,440,2200,180]],"platforms":[[760,360,160,20]],"hazards":[],"actions":actions,"required":[],"checkpoints":[]}
	install_scene(data,Vector2(120,440))
	if done:ui.show_dialogue(["Aion: Hızlı yardım etmek istiyordum; dinlemek de bir eylemmiş. Kurt: Etiketler kader değil. Kuzu: Sorularım yolu değiştirdi. Ömer: Bilmediğimi söylemekten korkmuyorum.\nVadi sihirle bütünüyle iyileşmedi. Deniz, Ece, İpek ve Aslı bakım ve izlemeyi sürdürüyor. Sen yaşam alanını gezebilir, bölümleri yeniden ziyaret edebilirsin.","Aion: I wanted to help fast; listening is an action too. Wolf: Labels are not destiny. Lamb: My questions changed our path. Ömer: I am not afraid to say I do not know.\nThe valley did not heal by magic. Deniz, Ece, İpek and Aslı continue care and monitoring. Explore the sanctuary or revisit the chapters."])
	else:ui.show_dialogue(["Duru güvenli bahçede dinleniyor. Yaban hayvanları kendi habitatlarında kalacak. İstersen burada dolaş; sağdaki çıkış nehre devam eder. İlerleme kaydedildi.","Duru is resting in the safe garden. Wildlife will remain in its own habitats. Explore here; the exit on the right continues to the river. Progress saved."])

func goal_text() -> String:
	if level_data.is_empty():return ""
	if in_hub:return State.text("Dostları ziyaret et · çıkış sağda","Visit friends · exit to the right")
	if not State.has_all(level_data.required):
		for a in level_data.actions:
			if not State.flags.get(a.id,false) and State.has_all(a.requires):
				if a.id=="a1l2.barrier_open" and State.flags.get("a1l2.route_crossed",false):continue
				return ui.tr_pair(a.label)
	for required in level_data.required:
		if State.flags.get(required,false):continue
		for a in level_data.actions:
			if a.id==required:return ui.tr_pair(a.label)
		if str(required).ends_with("arrived"):return State.text("Güvenli yolu aç ve hayvana alan bırak","Open a safe path and give the animal space")
		if required=="a1l2.route_crossed":return State.text("Bariyeri alt veya üst yoldan aş","Cross the barrier below or above")
	return State.text("Sağdaki çıkışa ulaş","Reach the exit on the right")

func nearest_action() -> Dictionary:
	if player==null:return {}
	var nearest: Dictionary={};var best=90.0
	for a in level_data.get("actions",[]):
		var distance=player.position.distance_to(Vector2(a.x,a.y))
		if distance<best:nearest=a;best=distance
	return nearest

func interact(ability: bool=false) -> void:
	if get_tree().paused:return
	var a=nearest_action()
	if not a.is_empty():
		if State.flags.get(a.id,false):
			if not ability:ui.show_dialogue(a.reply)
			return
		if not State.has_all(a.requires):ui.flash("Önce önceki güvenlik adımını tamamla.","Complete the preceding safety step first.");audio.cue(false);return
		if not a.heroes.is_empty() and not a.heroes.any(func(h):return int(h)==State.active):
			ui.flash("Bu düzenek için karakter "+str(int(a.heroes[0])+1)+" gerekli. Q ile takım menüsü.","This mechanism needs character "+str(int(a.heroes[0])+1)+". Q opens the party.");return
		if a.has("unlock") and not int(a.unlock) in State.unlocked:State.unlocked.append(int(a.unlock))
		for flag in a.get("sets",[]):State.mark(flag)
		if a.id=="a4l2.animal_in_care":State.animals["coast_patient"]={"habitat":"coast_care","status":"in_care"}
		player.action_time=0.38
		State.mark(a.id);audio.cue();ui.show_dialogue(a.reply);return
	if player.position.x>float(level_data.length)-180 and not ability:
		if in_hub:
			if State.flags.get("story_complete",false):ui.show_chapters()
			else:load_level(State.level,true)
		elif State.has_all(level_data.required):finish_level()
		else:ui.flash("Henüz bitmedi: "+goal_text(),"Not finished yet: "+goal_text())

func finish_level() -> void:
	var index=State.level
	if not index in State.completed:State.completed.append(index)
	State.checkpoints.erase(level_data.id)
	if index==9:
		State.mark("story_complete");State.save_game();load_hub()
	else:
		State.level=index+1;State.save_game()
		if index==1:load_hub()
		else:load_level(index+1,false)

func _physics_process(dt: float) -> void:
	if player==null:return
	play_seconds+=dt
	player.wind=world.wind_at(player.position)
	world.camera_x=player.get_node("Camera2D").get_screen_center_position().x-get_viewport().get_visible_rect().size.x/2
	if not in_hub:
		if level_data.id=="a1l2" and player.position.x>float(level_data.route_threshold):State.mark("a1l2.route_crossed")
		for i in level_data.checkpoints.size():
			var x=float(level_data.checkpoints[i])
			if absf(player.position.x-x)<28 and player.is_on_floor() and absf(player.position.y-440)<4 and i!=last_cp:
				last_cp=i;player.spawn=Vector2(x,440);State.checkpoints[level_data.id]=[x,440];State.save_game();ui.flash("Kontrol noktası · kayıt alındı","Checkpoint · saved")
		if world.unsafe_at(player.position) and player.invulnerable<=0:
			if State.prefs.story:
				player.invulnerable=1.4;player.velocity=Vector2(-player.facing*130,-200);ui.flash("Uyarı: çark çalışıyor. İçi boşken güvenli.","Warning: active gear. Wait for the empty centre.")
			else:player.retry()
	if not State.prefs.reduced_effects:
		ui.hud.modulate=Color.WHITE

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:return
	if event.is_action_pressed("pause"):ui.show_pause();get_viewport().set_input_as_handled();return
	if event.is_action_pressed("party"):ui.show_party();get_viewport().set_input_as_handled();return
	if event.is_action_pressed("journal"):ui.show_journal();get_viewport().set_input_as_handled();return
	for i in 4:
		if event.is_action_pressed("hero"+str(i)):player.switch_hero(i);get_viewport().set_input_as_handled();return
	if event.is_action_pressed("interact"):interact();get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED,NOTIFICATION_WM_WINDOW_FOCUS_OUT] and is_instance_valid(ui) and ui.menu_kind=="":ui.show_pause()

func publish_qa(dt: float) -> void:
	if OS.is_debug_build() and OS.has_feature("web") and OS.get_cmdline_user_args().has("--qa"):
		qa_clock+=dt
		if qa_clock>0.1:
			qa_clock=0.0
			var sample={"x":player.position.x,"y":player.position.y,"vx":player.velocity.x,"vy":player.velocity.y,"floor":player.is_on_floor(),"active":State.active,"cooldown":player.cooldown,"unlocked":State.unlocked,"flags":State.flags,"level":State.level,"hub":in_hub,"menu":ui.menu_kind,"completed":State.completed,"shape_height":player.body_shape.shape.size.y,"glide":player.glide_left}
			sample.performance={"fps":Engine.get_frames_per_second(),"static_memory_bytes":Performance.get_monitor(Performance.MEMORY_STATIC),"draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)}
			JavaScriptBridge.eval("window.__planetQA="+JSON.stringify(sample))
