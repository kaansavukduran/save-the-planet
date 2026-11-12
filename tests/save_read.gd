extends SceneTree
func _initialize() -> void:call_deferred("run")
func run() -> void:
	await process_frame
	var state=root.get_node("State");state.path="user://restart-test.json"
	var ok=state.load_game() and state.flags.get("restart.marker",false) and state.level==5 and state.active==3 and state.unlocked==[0,1,2,3] and state.completed==[0,1,2,3,4]
	print("INDEPENDENT PROCESS SAVE REOPEN: ",ok)
	quit(0 if ok else 1)
