extends SceneTree
var game: Node
var state: Node
var failures: Array=[]
var checks: Array=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool,label: String) -> void:
	checks.append({"check":label,"pass":ok})
	if not ok:failures.append(label);push_error(label)
func ticks(n: int) -> void:
	for i in n:await physics_frame
func press(action: String,n: int=1) -> void:
	Input.action_press(action);await ticks(n);Input.action_release(action);await ticks(1)
func run() -> void:
	await process_frame
	state=root.get_node("State");state.path="user://acceptance.json";state.new_game()
	game=load("res://scenes/main.tscn").instantiate();root.add_child(game);await ticks(3);game.ui.close_panel();game.load_level(0,false,false)
	state.unlocked=[0,1,2,3]
	var p=game.player
	# Set up an airborne scenario; actual controls and physics must preserve the shared budget.
	p.position=Vector2(200,80);p.velocity=Vector2.ZERO;p.jumps=2;p.glide_left=0.2;p.cooldown=0.7
	var initial_y=p.position.y
	Input.action_press("jump")
	for i in 30:p.switch_hero(3 if i%2==0 else 0);await ticks(1)
	Input.action_release("jump")
	check(p.position.y>initial_y,"03 Air switching cannot create upward motion after jumps are spent")
	check(p.jumps==2 and p.glide_left<=0.2,"03 Shared jumps and glide budget survive 30 switches")
	check(p.cooldown>0 and p.cooldown<0.7,"03 Switching does not refresh cooldown")
	# Wolf dash against a real solid gate, switch repeatedly while holding ability.
	p.position=Vector2(1010,440);p.velocity=Vector2.ZERO;p.cooldown=0;p.switch_hero(1);await ticks(3)
	Input.action_press("ability");await ticks(2)
	var max_speed=absf(p.velocity.x)
	for i in 20:
		p.switch_hero(i%4);await ticks(1);max_speed=maxf(max_speed,absf(p.velocity.x))
	Input.action_release("ability")
	check(max_speed<=420.1 and p.position.x<1100,"04 Dash switching cannot stack speed or cross a closed gate")
	# Tunnel: use actual roll input to enter, then reject a larger body until outside.
	p.position=Vector2(1880,440);p.velocity=Vector2.ZERO;p.cooldown=0;p.switch_hero(2);p.facing=1
	Input.action_press("right");await press("ability",17)
	check(p.position.x>1940 and p.body_shape.shape.size.y==26,"05 Lamb roll physically enters the low tunnel")
	check(not p.switch_hero(0),"05 Unsafe body switch is rejected in the tunnel")
	await ticks(70);Input.action_release("right");await ticks(2)
	check(p.switch_hero(0) and p.body_shape.shape.size.y==54,"05 Larger body is allowed after leaving tunnel")
	# Paused party and dialogue must freeze physics and ignore background jump/ability.
	var before=p.position;var clock=game.world.clock;var cooldown=p.cooldown
	game.ui.show_party();Input.action_press("jump");Input.action_press("ability");await ticks(35)
	check(p.position==before and game.world.clock==clock and p.cooldown==cooldown,"10 Party menu freezes movement, hazards and cooldowns")
	game.ui.close_panel();await ticks(2)
	check(p.velocity.y>=0,"10 Closing a menu does not replay its jump input")
	game.ui.show_dialogue(["Test konuşması","Test dialogue"]);before=p.position;await ticks(20)
	check(p.position==before,"10 Dialogue freezes physics")
	game.ui.close_panel()
	# Focus release independent of OS/browser.
	Input.action_press("right");root.get_node("Controls")._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(not Input.is_action_pressed("right"),"11 Focus loss releases held actions")
	# Real moving-platform contact and carrying, then a character switch.
	game.load_level(3,false,false);p=game.player
	var m=game.world.moving[0]
	p.position=m.body.position-Vector2(0,float(m.size.y)/2);p.velocity=Vector2.ZERO;await ticks(12)
	var old_x=p.position.x;p.switch_hero(3);await ticks(35)
	check(p.is_on_floor() and absf(p.position.x-old_x)>10,"06 Moving platform carries the switched character")
	# A recovery must snap both physics position and camera target.
	p.position=Vector2(3500,600);p.retry();await ticks(2)
	check(p.position.distance_to(p.spawn)<3,"08 Retry returns to a safe checkpoint immediately")
	# Repeated real rescue events, scene reconstruction and stable IDs.
	game.load_level(0,false,false);p=game.player;p.position=Vector2(420,440);game.interact();game.ui.close_panel()
	p.position=Vector2(1050,440);game.interact();game.ui.close_panel();await ticks(520)
	check(state.animals.size()==1 and state.flags.get("a1l1.duru_arrived",false),"07 Animal autonomously reaches safety once")
	game.load_level(0,false,false);await ticks(10)
	check(state.animals.size()==1 and game.world.actor_done,"07 Reloading the rescue scene cannot duplicate the individual")
	# Actual save writes, corruption fallback and schema migration.
	state.prefs.language="en";state.prefs.large_text=true;state.save_game();state.save_game()
	var snapshot=state.snapshot().duplicate(true)
	var f=FileAccess.open(state.path,FileAccess.WRITE);f.store_string("{truncated");f.close()
	state.flags.clear();check(state.load_game() and state.flags.get("a1l1.duru_arrived",false),"09 Corrupt primary recovers the valid backup")
	check(state.prefs.language=="en" and state.prefs.large_text,"08 Language and accessibility preferences survive reload")
	snapshot.schema_version=1
	f=FileAccess.open(state.path,FileAccess.WRITE);f.store_string(JSON.stringify(snapshot));f.close()
	check(state.load_game() and state.animals.size()==1,"09 Schema 1 migration preserves world facts and animals")
	snapshot.schema_version=99
	f=FileAccess.open(state.path,FileAccess.WRITE);f.store_string(JSON.stringify(snapshot));f.close()
	check(not state.load_game() and not state.save_game(),"09 Future save is preserved without overwriting")
	state.protected_future=false
	# Persist a marker for an independent process read in save_read.gd.
	state.path="user://restart-test.json";state.flags={"restart.marker":true};state.unlocked=[0,1,2,3];state.active=3;state.level=5;state.completed=[0,1,2,3,4];state.save_game()
	var output=FileAccess.open("res://work/acceptance-results.json",FileAccess.WRITE);output.store_string(JSON.stringify({"checks":checks,"failures":failures},"  "));output.close()
	print("ACCEPTANCE CHECKS: ",checks.size()," FAILURES: ",failures)
	game.queue_free();await process_frame;quit(0 if failures.is_empty() else 1)
