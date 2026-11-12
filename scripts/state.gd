extends Node
## Durable world facts survive retries. Checkpoints store safe feet positions only.
signal changed
const SCHEMA = 2
const VERSION = "0.1.0"
var path = "user://planet-save.json"
var flags: Dictionary = {}
var animals: Dictionary = {}
var checkpoints: Dictionary = {}
var completed: Array = []
var unlocked: Array = [0]
var active = 0
var level = 0
var prefs = {"language":"tr", "story":true, "large_text":false, "reduced_effects":false, "music":0.35, "sfx":0.65, "touch":false, "bindings":{}}
var notice = ""
var history: Array = []
var protected_future = false
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
	flags.clear(); animals.clear(); checkpoints.clear(); completed.clear(); history.clear()
	unlocked = [0]; active = 0; level = 0
	save_game()

func snapshot() -> Dictionary:
	return {"schema_version":SCHEMA,"game_version":VERSION,"level":level,"active":active,"flags":flags,"animals":animals,"checkpoints":checkpoints,"completed":completed,"unlocked":unlocked,"prefs":prefs,"history":history}

func valid(d: Variant) -> bool:
	if not d is Dictionary: return false
	if not d.get("schema_version") is float and not d.get("schema_version") is int: return false
	if int(d.schema_version) < 1: return false
	for k in ["flags","animals","checkpoints","prefs"]:
		if not d.get(k) is Dictionary: return false
	for k in ["completed","unlocked"]:
		if not d.get(k) is Array: return false
	if not d.get("level") is float and not d.get("level") is int: return false
	if int(d.level)<0 or int(d.level)>9: return false
	for i in d.unlocked:
		if not i is float and not i is int: return false
		if int(i)<0 or int(i)>3: return false
	if d.unlocked.is_empty(): return false
	for i in d.completed:
		if not i is float and not i is int:return false
		if int(i)<0 or int(i)>9:return false
	for flag in d.flags.values():
		if not flag is bool:return false
	for animal in d.animals.values():
		if not animal is Dictionary or not animal.get("habitat") is String or not animal.get("status") is String:return false
	if d.prefs.has("bindings") and not d.prefs.bindings is Dictionary:return false
	if d.has("history"):
		if not d.history is Array:return false
		for pair in d.history:
			if not pair is Array or pair.size()!=2:return false
			if not pair[0] is String or not pair[1] is String:return false
	for key in d.prefs.get("bindings",{}):
		var code=d.prefs.bindings[key]
		if not code is float and not code is int:return false
	for c in d.checkpoints.values():
		if not c is Array or c.size()!=2: return false
		for n in c:
			if not n is float and not n is int: return false
		if float(c[0])<0 or float(c[0])>7000 or float(c[1])<0 or float(c[1])>500: return false
	return true

func parse_save(raw: String) -> Variant:
	var parser=JSON.new()
	return parser.data if parser.parse(raw)==OK else null

func load_game() -> bool:
	var candidates: Array=[]
	if OS.has_feature("web"):
		for key in [WEB_KEY,WEB_KEY+".bak"]:
			var raw=JavaScriptBridge.eval("(()=>{try{return localStorage.getItem("+JSON.stringify(key)+")}catch(e){return null}})()")
			if raw is String:candidates.append({"name":key,"raw":raw})
	for file in [path,path+".bak"]:
		if FileAccess.file_exists(file):candidates.append({"name":file,"raw":FileAccess.get_file_as_string(file)})
	for record in candidates:
		var candidate: String=record.name
		var d = parse_save(record.raw)
		if d is Dictionary and (d.get("schema_version") is float or d.get("schema_version") is int) and int(d.schema_version)>SCHEMA:
			protected_future=true;notice="Bu kayıt daha yeni bir sürüme ait. Korundu. / Newer save preserved.";return false
		if not valid(d): continue
		if int(d.schema_version)>SCHEMA:
			protected_future = true
			notice = "Bu kayıt daha yeni bir sürüme ait. Korundu. / Newer save preserved."
			return false
		flags = d.flags; animals = d.animals; checkpoints = d.checkpoints
		completed = d.completed.map(func(i):return int(i)); unlocked = d.unlocked.map(func(i):return int(i))
		level = int(d.level); active = clampi(int(d.get("active",0)),0,3)
		if not active in unlocked: active = int(unlocked[0])
		for k in prefs:
			if d.prefs.has(k) and typeof(d.prefs[k])==typeof(prefs[k]): prefs[k]=d.prefs[k]
		if not prefs.language in ["tr","en"]: prefs.language = "tr"
		prefs.music = clampf(float(prefs.music),0,1); prefs.sfx = clampf(float(prefs.sfx),0,1)
		history = d.get("history",[]) if d.get("history",[]) is Array else []
		if candidate.ends_with(".bak"): notice="Son geçerli kayıt kurtarıldı. / Last valid save recovered."
		if int(d.schema_version)<SCHEMA: notice="Kayıt ilerleme korunarak güncellendi. / Save migrated."
		return true
	if FileAccess.file_exists(path): notice="Bozuk kayıt korundu; yeni oyun açılabilir. / Corrupt save preserved; New Game available."
	return false

func save_game() -> bool:
	if protected_future: return false
	var f = FileAccess.open(path+".tmp",FileAccess.WRITE)
	if f == null:
		notice="Kayıt yazılamadı. / Could not save.";return false
	f.store_string(JSON.stringify(snapshot()));f.flush();f.close()
	var abs_path=ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(path):
		var old=parse_save(FileAccess.get_file_as_string(path))
		if valid(old):
			if DirAccess.copy_absolute(abs_path,abs_path+".bak")!=OK:return false
	if DirAccess.rename_absolute(abs_path+".tmp",abs_path)!=OK:
		notice="Kayıt değiştirilemedi. / Could not replace save.";return false
	if OS.has_feature("web"):
		var raw=JSON.stringify(snapshot())
		var key_literal=JSON.stringify(WEB_KEY)
		var previous=JavaScriptBridge.eval("(()=>{try{return localStorage.getItem("+key_literal+")}catch(e){return null}})()")
		if previous is String and valid(parse_save(previous)):
			JavaScriptBridge.eval("try{localStorage.setItem("+JSON.stringify(WEB_KEY+".bak")+","+JSON.stringify(previous)+")}catch(e){}")
		var stored=JavaScriptBridge.eval("(()=>{try{localStorage.setItem("+key_literal+","+JSON.stringify(raw)+");return true}catch(e){return false}})()")
		JavaScriptBridge.force_fs_sync()
		if stored!=true:notice="Tarayıcı anlık yedeği yazılamadı; dosya kaydı kullanılıyor. / Browser snapshot unavailable; using file persistence."
	return true
