extends SceneTree
## Exercise the real Sprite2D transforms and opacity bounds, not only metadata.
var checks: Array=[]
var samples: Array=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool,label: String) -> void:
	checks.append({"check":label,"status":"PASS" if ok else "FAIL"})
	if not ok:push_error(label)
func run() -> void:
	await process_frame
	var parent=Node2D.new();root.add_child(parent)
	var visual=HeroVisual.new();parent.add_child(visual);visual.set_process(false)
	var total_frames=0
	for hero in 4:
		var poses=["idle","run","jump","interact","rest","roll"]
		if hero==1:poses.append("dash")
		if hero==3:poses.append("glide")
		for pose in poses:
			var worst_contact=0.0;var worst_origin=0.0;var min_x=INF;var max_x=-INF
			for size in [0.8,1.0,1.1]:
				parent.scale=Vector2.ONE*size;parent.position=Vector2(300,400)
				for direction in [-1,1]:
					for index in 8:
						visual.hero=hero;visual.pose=pose;visual.facing=direction
						visual.clock=(index+0.01)/(13.0 if pose in ["run","roll","dash"] else 7.0)
						visual.refresh();total_frames+=1
						var snap=visual.render_snapshot();var b=snap.opaque_bounds;var point=snap.root
						var bottom=(b[1]+b[3]-point[1])/size
						worst_contact=maxf(worst_contact,maxf(bottom,0.0) if pose=="roll" else absf(bottom))
						worst_origin=maxf(worst_origin,visual.sprite.position.length())
						var center=(b[0]+b[2]/2.0-point[0])*direction/size
						min_x=minf(min_x,center);max_x=maxf(max_x,center)
			check(worst_contact<0.02,"Hero %d %s: opaque feet never sink at any frame, facing or menu scale"%[hero,pose])
			check(worst_origin<0.001,"Hero %d %s: animation never translates the sprite node away from its body"%[hero,pose])
			if pose=="idle":check(max_x-min_x<0.02,"Hero %d: blink cycle has no horizontal registration drift in either facing"%hero)
			samples.append({"hero":hero,"pose":pose,"worst_contact_error":worst_contact,"horizontal_extent":max_x-min_x})
	var failures=checks.filter(func(c):return c.status=="FAIL")
	var file=FileAccess.open("res://work/sprite-alignment-results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks":checks,"samples":samples,"rendered_frame_configurations":total_frames},"  "));file.close()
	print("SPRITE ALIGNMENT: ",checks.size()," checks, ",total_frames," configurations, failures: ",failures)
	parent.queue_free();await process_frame;quit(0 if failures.is_empty() else 1)
