extends SceneTree
## Integration: traverses real collision geometry and invokes actual interaction/exit handlers.
## Never injects world facts, rescues, unlocks, story completion or player coordinates.
var game: Node
var state: Node
var failures: Array = []
var report: Array = []
func _initialize() -> void:call_deferred("run")
func check(ok: bool,message: String) -> void:
	report.append({"check":message,"pass":ok})
	if not ok:failures.append(message);push_error(message)
func ticks(n: int) -> void:
	for i in n:await physics_frame
func release() -> void:
	for action in ["left","right","jump","ability","down"]:Input.action_release(action)
func close_dialogue() -> void:
	if game.ui.menu_kind!="":game.ui.close_panel()

func walk_to(target: float) -> bool:
	var last_x=-1000.0;var stuck=0;var jump_held=0
	for frame in 2800:
		var p=game.player
		var distance=target-p.position.x
		if absf(distance)<18:
			release()
			for wait in 130:
				if absf(game.player.position.y-440)<5 and game.player.is_on_floor():break
				Input.action_press("down");await physics_frame
			Input.action_release("down");await ticks(3);return true
		var direction="right" if distance>0 else "left"
		Input.action_release("left" if distance>0 else "right");Input.action_press(direction)
		var tunnel=game.level_data.get("tunnel",[])
		var inside=tunnel.size()>0 and p.position.x>float(tunnel[0])-65 and p.position.x<float(tunnel[0])+float(tunnel[2])+40
		if inside:
			if state.active!=2:p.switch_hero(2)
			if p.cooldown<=0:Input.action_press("ability")
			else:Input.action_release("ability")
		else:Input.action_release("ability")
		if game.ui.menu_kind!="":close_dialogue()
		if absf(p.position.x-last_x)<0.2:stuck+=1
		else:stuck=0
		last_x=p.position.x
		var gap_ahead=false
		if not inside and direction=="right":
			for g in game.level_data.ground:
				var edge=float(g[0]+g[2])
				if p.position.x>edge-70 and p.position.x<edge-4 and edge<float(game.level_data.length)-10:gap_ahead=true
		if not inside and (stuck>12 or gap_ahead) and p.is_on_floor():
			if 0 in state.unlocked:p.switch_hero(0)
			Input.action_press("jump");jump_held=1
		elif jump_held>0:
			jump_held+=1
			if jump_held==24:Input.action_release("jump")
			if jump_held==26 and not p.is_on_floor() and state.active==0:Input.action_press("jump")
			if jump_held>55:Input.action_release("jump");jump_held=0
		await physics_frame
		if p.position.x>target+120 and direction=="right":release()
	print("WALK TIMEOUT target=",target," pos=",game.player.position," hero=",state.active," shape=",game.player.body_shape.shape.size," paused=",paused)
	release();return false

func run() -> void:
	await process_frame
	state=root.get_node("State");state.path="user://campaign-integration.json";state.new_game()
	game=load("res://scenes/main.tscn").instantiate();root.add_child(game)
	await ticks(3);game.ui.close_panel();game.load_level(0,false,false)
	for index in 10:
		if game.in_hub:
			close_dialogue();await walk_to(float(game.level_data.length)-100);game.interact();close_dialogue()
		check(state.level==index,"Campaign reached chapter "+str(index+1))
		close_dialogue();await ticks(5)
		var data: Dictionary=game.level_data
		for a in data.actions:
			if state.flags.get(a.id,false):continue
			if not state.has_all(a.requires):
				# Autonomous animals must actually traverse the world before the next meeting.
				await ticks(650)
			var reached=await walk_to(float(a.x)-38)
			check(reached,data.id+" physically reached "+a.id)
			if not reached:break
			if not a.heroes.is_empty():
				game.player.switch_hero(int(a.heroes[0]))
				await ticks(3)
			game.interact();
			if not state.flags.get(a.id,false):print("INTERACTION FAILED ",a.id," pos ",game.player.position," hero ",state.active," nearest ",game.nearest_action().get("id","none")," requires ",a.requires)
			close_dialogue();await ticks(4)
			check(state.flags.get(a.id,false),data.id+" interaction "+a.id)
			if a.has("timer"):await ticks(260)
		if data.has("animal") and not state.flags.get(data.animal.arrived,false):await ticks(700)
		check(state.has_all(data.required),data.id+" all mandatory conditions")
		if not state.has_all(data.required):break
		var reached_exit=await walk_to(float(data.length)-100)
		check(reached_exit,data.id+" physically reached exit")
		if not reached_exit:break
		game.interact();close_dialogue();await ticks(3)
		check(index in state.completed,data.id+" exit persisted")
	check(state.flags.get("story_complete",false),"story_complete saved after chapter ten")
	check(state.completed.size()==10,"All ten chapters completed")
	check(state.animals.size()==4,"One Duru, two wildlife individuals, one coastal patient")
	check(game.in_hub,"Interactive epilogue sanctuary reached")
	var f=FileAccess.open("res://work/campaign-results.json",FileAccess.WRITE);f.store_string(JSON.stringify({"checks":report,"failures":failures,"simulated_seconds":game.play_seconds,"retries":game.attempts},"  "));f.close()
	print("CAMPAIGN CHECKS: ",report.size()," FAILURES: ",failures)
	game.queue_free();await process_frame;quit(0 if failures.is_empty() else 1)
