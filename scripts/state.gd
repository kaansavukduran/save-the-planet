extends Node
## Durable world facts survive retries. Checkpoints store safe feet positions only.
signal changed
const SCHEMA = 2
const VERSION = "0.4.0"
const MAX_SAVE_BYTES = 262144
const DEFAULT_PREFS = {"language":"tr", "story":true, "large_text":false, "reduced_effects":false, "music":0.35, "sfx":0.65, "touch":false, "bindings":{}, "gamepad_bindings":{}, "deadzone":0.25, "theme":"dark", "font":"system", "touch_intro_seen":false}
var path = "user://planet-save.json"
var flags: Dictionary = {}
var animals: Dictionary = {}
var checkpoints: Dictionary = {}
var completed: Array = []
var unlocked: Array = [0]
var active = 0
var level = 0
var prefs = DEFAULT_PREFS.duplicate(true)
var notice = ""
var history: Array = []
var protected_future = false
var storage_paused = true
var storage_error = false
var unknown_save = false
const WEB_KEY="fragaria.save-the-planet.v2"

func _ready() -> void:
	if OS.get_cmdline_user_args().has("--test-save"):
		path = "user://planet-test.json"
	load_game()

func text(tr_text: String, en_text: String) -> String:
	return tr_text if prefs.language == "tr" else en_text

func mark(id: String) -> bool:
	if flags.get(id,false): return false
	flags[id] = true
	changed.emit()
	save_game()
	return true

func has_all(ids: Array) -> bool:
	for id in ids:
		if not flags.get(str(id),false): return false
	return true

func new_game() -> void:
	# Explicit New Game is the only operation that replaces progress.
	protected_future = false
	unknown_save = false
	storage_paused = false
	clear_progress()
	save_game(true)

func clear_progress() -> void:
	flags.clear(); animals.clear(); checkpoints.clear(); completed.clear(); history.clear()
	unlocked = [0]; active = 0; level = 0

func save_preferences() -> bool:
	# A deliberate setting change may store preferences again after erasure.
	storage_paused = false
	return save_game()

func snapshot() -> Dictionary:
	return {"schema_version":SCHEMA,"game_version":VERSION,"level":level,"active":active,"flags":flags,"animals":animals,"checkpoints":checkpoints,"completed":completed,"unlocked":unlocked,"prefs":prefs,"history":history}

func whole_number(value: Variant) -> bool:
	return value is int or (value is float and is_finite(value) and value==floor(value) and absf(value)<1000000000)

func valid(d: Variant) -> bool:
	if not d is Dictionary or not whole_number(d.get("schema_version")):return false
	if int(d.schema_version)<1:return false
	for key in ["flags","animals","checkpoints","prefs"]:
		if not d.get(key) is Dictionary:return false
	for key in ["completed","unlocked"]:
		if not d.get(key) is Array:return false
	if not whole_number(d.get("level")) or int(d.level)<0 or int(d.level)>9:return false
	if not whole_number(d.get("active",0)) or int(d.get("active",0))<0 or int(d.get("active",0))>3:return false
	if d.unlocked.is_empty() or d.unlocked.size()>4 or d.completed.size()>10:return false
	for id in d.unlocked:
		if not whole_number(id) or int(id)<0 or int(id)>3:return false
	for id in d.completed:
		if not whole_number(id) or int(id)<0 or int(id)>9:return false
	if d.flags.size()>512 or d.animals.size()>32 or d.checkpoints.size()>32:return false
	for flag in d.flags.values():
		if not flag is bool:return false
	for animal in d.animals.values():
		if not animal is Dictionary or not animal.get("habitat") is String or not animal.get("status") is String:return false
	for key in ["music","sfx","deadzone"]:
		if d.prefs.has(key):
			var value=d.prefs[key]
			if (not value is float and not value is int) or not is_finite(float(value)):return false
	for key in ["theme","font"]:
		if d.prefs.has(key) and not d.prefs[key] in ({"theme":["dark","light","system"],"font":["system","bundled"]}[key]):return false
	for key in ["bindings","gamepad_bindings"]:
		var bindings=d.prefs.get(key,{})
		if not bindings is Dictionary or bindings.size()>20:return false
		for action in bindings:
			var code=bindings[action]
			if not action is String or not whole_number(code):return false
			if int(code)<0 or int(code)>(21 if key=="gamepad_bindings" else 16777216):return false
	if d.has("history"):
		if not d.history is Array or d.history.size()>100:return false
		for pair in d.history:
			if not pair is Array or pair.size()!=2:return false
			for line in pair:
				if not line is String or line.length()>4096:return false
	for checkpoint in d.checkpoints.values():
		if not checkpoint is Array or checkpoint.size()!=2:return false
		for value in checkpoint:
			if (not value is float and not value is int) or not is_finite(float(value)):return false
		if float(checkpoint[0])<0 or float(checkpoint[0])>7000 or float(checkpoint[1])<0 or float(checkpoint[1])>500:return false
	return true

func parse_save(raw: String) -> Variant:
	if raw.to_utf8_buffer().size()>MAX_SAVE_BYTES:return null
	var parser=JSON.new()
	return parser.data if parser.parse(raw)==OK else null

func read_save_file(file: String) -> String:
	var handle=FileAccess.open(file,FileAccess.READ)
	if handle==null or handle.get_length()>MAX_SAVE_BYTES:return ""
	return handle.get_as_text()

func load_game() -> bool:
	var candidates: Array=[]
	if OS.has_feature("web"):
		var storage=JavaScriptBridge.get_interface("planetStorage")
		if storage!=null and bool(storage.erased()):
			# A synchronous erase marker prevents an older IndexedDB snapshot returning
			# if the tab reloads before the asynchronous filesystem deletion finishes.
			for file in [path,path+".bak",path+".tmp"]:
				if FileAccess.file_exists(file):DirAccess.remove_absolute(ProjectSettings.globalize_path(file))
			JavaScriptBridge.force_fs_sync()
			return false
		for key in [WEB_KEY,WEB_KEY+".bak"]:
			var raw=storage.read(key) if storage!=null else null
			if raw is String:candidates.append({"name":key,"raw":raw})
	for file in [path,path+".bak"]:
		if FileAccess.file_exists(file):candidates.append({"name":file,"raw":read_save_file(file)})
	for record in candidates:
		var candidate: String=record.name
		var d = parse_save(record.raw)
		if d is Dictionary and whole_number(d.get("schema_version")) and int(d.schema_version)>SCHEMA:
			protected_future=true;notice="Bu kayıt daha yeni bir sürüme ait. Korundu. / Newer save preserved.";return false
		if not valid(d): continue
		if int(d.schema_version)>SCHEMA:
			protected_future = true
			notice = "Bu kayıt daha yeni bir sürüme ait. Korundu. / Newer save preserved."
			return false
		flags = d.flags; animals = d.animals; checkpoints = d.checkpoints
		storage_paused=false
		unknown_save=false
		completed = d.completed.map(func(i):return int(i)); unlocked = d.unlocked.map(func(i):return int(i))
		level = int(d.level); active = clampi(int(d.get("active",0)),0,3)
		if not active in unlocked: active = int(unlocked[0])
		for k in prefs:
			if d.prefs.has(k) and typeof(d.prefs[k])==typeof(prefs[k]): prefs[k]=d.prefs[k]
		if not prefs.language in ["tr","en"]: prefs.language = "tr"
		prefs.music = clampf(float(prefs.music),0,1); prefs.sfx = clampf(float(prefs.sfx),0,1)
		prefs.deadzone = clampf(float(prefs.deadzone),0.15,0.5)
		history = d.get("history",[]) if d.get("history",[]) is Array else []
		if candidate.ends_with(".bak"): notice="Son geçerli kayıt kurtarıldı. / Last valid save recovered."
		if int(d.schema_version)<SCHEMA: notice="Kayıt ilerleme korunarak güncellendi. / Save migrated."
		return true
	if not candidates.is_empty():
		unknown_save=true
		notice="Bozuk kayıt korundu; yeni oyun açılabilir. / Corrupt save preserved; New Game available."
	return false

func save_game(replace_existing: bool=false) -> bool:
	if storage_paused:return false
	if protected_future:return save_error("Bu kayıt yeni sürüme ait; üzerine yazılmadı. / Newer save kept; no overwrite.")
	if unknown_save:return save_error("Okunamayan kayıt korundu. Değiştirmek için Yeni yolculuk seç. / Unreadable save kept. Choose New journey to replace it.")
	if OS.has_feature("web") and not replace_existing:
		var storage=JavaScriptBridge.get_interface("planetStorage")
		var raw=storage.read(WEB_KEY) if storage!=null else null
		var current=parse_save(raw) if raw is String else null
		if current is Dictionary and whole_number(current.get("schema_version")) and int(current.schema_version)>SCHEMA:
			protected_future=true
			return save_error("Yeni sürüme ait tarayıcı kaydı korundu. / Newer browser save preserved.")
	var f = FileAccess.open(path+".tmp",FileAccess.WRITE)
	if f == null:
		return save_error("Kayıt yazılamadı. İlerleme bu oturumda korunuyor. / Could not save. Progress remains in this session.")
	f.store_string(JSON.stringify(snapshot()));f.flush()
	var write_result=f.get_error()
	f.close()
	if write_result!=OK:return save_error("Kayıt tamamlanamadı. Bu oturumu açık tutup yeniden dene. / Save did not finish. Keep this session open and retry.")
	var abs_path=ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(path):
		var old=parse_save(read_save_file(path))
		if not replace_existing and old is Dictionary and whole_number(old.get("schema_version")) and int(old.schema_version)>SCHEMA:
			protected_future=true
			DirAccess.remove_absolute(abs_path+".tmp")
			return save_error("Yeni sürüme ait kayıt korundu. / Newer save preserved.")
		if valid(old):
			if DirAccess.copy_absolute(abs_path,abs_path+".bak")!=OK:return save_error("Kayıt yedeği yazılamadı. / Could not write save backup.")
	if DirAccess.rename_absolute(abs_path+".tmp",abs_path)!=OK:
		return save_error("Kayıt değiştirilemedi. / Could not replace save.")
	storage_error=false
	if OS.has_feature("web"):
		var raw=JSON.stringify(snapshot())
		var storage=JavaScriptBridge.get_interface("planetStorage")
		if storage==null:return save_error("Tarayıcı kaydı kullanılamıyor. / Browser storage is unavailable.")
		var previous=storage.read(WEB_KEY)
		if previous is String and valid(parse_save(previous)):
			storage.write(WEB_KEY+".bak",previous)
		var stored=storage.write(WEB_KEY,raw)
		JavaScriptBridge.force_fs_sync()
		if not bool(stored):return save_error("Tarayıcı kaydı kısıtlıyor. Sayfayı kapatınca son değişiklikler kaybolabilir. / Browser storage is restricted. Recent changes may be lost on close.")
	return true

func save_error(message: String) -> bool:
	notice=message
	storage_error=true
	return false

func erase_local_data() -> bool:
	# Remove only this game's known files/keys. Never clear the whole origin.
	storage_paused=true
	var removed=true
	for file in [path,path+".bak",path+".tmp"]:
		if FileAccess.file_exists(file):
			if OS.has_feature("web"):
				# IDBFS may still be reading an earlier file set. Truncate contents
				# now; the erase marker lets the next boot unlink safely before play.
				var handle=FileAccess.open(file,FileAccess.WRITE)
				if handle==null:removed=false
				else:
					handle.flush()
					removed=(handle.get_error()==OK) and removed
					handle.close()
			else:removed=(DirAccess.remove_absolute(ProjectSettings.globalize_path(file))==OK) and removed
	if OS.has_feature("web"):
		var storage=JavaScriptBridge.get_interface("planetStorage")
		removed=(bool(storage.erase_all()) if storage!=null else false) and removed
		JavaScriptBridge.force_fs_sync()
	if not removed:return save_error("Verilerin tamamı silinemedi. Yeniden dene. / Some data could not be deleted. Try again.")
	clear_progress()
	prefs=DEFAULT_PREFS.duplicate(true)
	protected_future=false
	unknown_save=false
	storage_error=false
	notice="Bu oyunun yerel verileri silindi. / This game's local data was deleted."
	changed.emit()
	return true
