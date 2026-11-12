extends SceneTree
var checks: Array=[]
var snapshots: Array=[]
func _initialize() -> void:call_deferred("run")
func frames(count: int=4) -> void:
	for i in count:await process_frame
func check(ok: bool,label: String) -> void:
	checks.append({"check":label,"status":"PASS" if ok else "FAIL"})
	if not ok:push_error(label)
func run() -> void:
	await process_frame
	var state=root.get_node("State");state.path="user://dialogue-audio-regression.json";state.new_game()
	var game=load("res://scenes/main.tscn").instantiate();root.add_child(game);await frames()
	for size in [Vector2i(2048,1024),Vector2i(844,390),Vector2i(390,844),Vector2i(320,568)]:
		root.size=size;await frames()
		for language in ["tr","en"]:
			for large in [false,true]:
				state.prefs.language=language;state.prefs.large_text=large;state.prefs.music=0.4
				game.ui.apply_preferences()
				var tr="Bu geçidi birlikte güvenli hale getirebiliriz. Önce dinleyip çevreyi inceleyelim. "
				var en="We can make this passage safe together. Let us listen and inspect the surroundings first. "
				var body=(tr if language=="tr" else en).repeat(9).strip_edges()
				game.ui.show_dialogue(["Kurt: "+tr.repeat(9),"Wolf: "+en.repeat(9)]);await frames(20)
				var info=game.ui.dialogue_snapshot();var label="%s %s large=%s"%[size,language,large]
				check(info.speaker_lines==1 and info.speaker_rect[2]>150,label+": speaker name is horizontal with real text width")
				check(info.portrait,label+": correct character portrait is present in both languages")
				check(info.header_rect[1]+info.header_rect[3]<=info.scroll_rect[1]+0.1,label+": fixed speaker header is outside the scrolling text")
				var right=info.scrollbar_rect[0] if info.scrollbar_visible else info.scroll_rect[0]+info.scroll_rect[2]
				check(info.body_rect[0]+info.body_rect[2]<=right-8,label+": body text leaves a scrollbar gutter")
				check(info.body_rect[1]<info.scroll_rect[1]+info.scroll_rect[3] and info.scroll_rect[3]>50,label+": dialogue body is actually visible")
				check(paused and game.audio.music.can_process() and not game.audio.music.stream_paused,label+": music continues while the world is paused")
				check(absf(game.audio.music.volume_linear-0.4*game.audio.DIALOGUE_GAIN)<0.005 and state.prefs.music==0.4,label+": smooth dialogue gain does not overwrite the volume preference")
				var position=game.player.position;await frames(5)
				check(game.player.position==position,label+": reading still freezes gameplay")
				var parts=[game.ui.dialogue_body.text];var speaker=info.speaker;var page=1;var speaker_stable=true
				while not game.ui.dialogue_pages.is_empty():
					game.ui.show_dialogue_page();await frames(4);page+=1;parts.append(game.ui.dialogue_body.text)
					if game.ui.dialogue_name.text!=speaker:speaker_stable=false
				check(speaker_stable and page==info.pages,label+": speaker and actual page count persist through continuation")
				check(" ".join(parts).split(" ",false)==body.split(" ",false),label+": pagination preserves all dialogue words")
				snapshots.append({"case":label,"first_page":info})
				game.ui.close_panel();await frames(20)
				check(not game.audio.dialogue_active and absf(game.audio.music.volume_linear-0.4)<0.005,label+": closing restores the chosen music level")
	state.prefs.language="tr";root.size=Vector2i(320,568);await frames()
	game.ui.show_dialogue(["Kurt: "+"Konuşma metni kaydırılabilmeli. ".repeat(8),"Wolf: Text should remain scrollable."])
	game.ui.dialogue_body.add_theme_font_size_override("font_size",42);await frames(8)
	var overflow=game.ui.dialogue_snapshot()
	check(overflow.scrollbar_visible,"Oversized text really uses the body scrollbar")
	check(overflow.body_rect[0]+overflow.body_rect[2]<=overflow.scrollbar_rect[0]-8,"Actual overflow still reserves a readable scrollbar gutter")
	game.ui.panel_scroll.scroll_vertical=int(game.ui.panel_scroll.get_v_scroll_bar().max_value);await frames()
	var visible=game.ui.dialogue_snapshot();var footer=game.ui.dialogue_next.get_global_rect()
	check(visible.header_rect[1]+visible.header_rect[3]<=visible.scroll_rect[1]+0.1 and footer.position.y>=visible.scroll_rect[1]+visible.scroll_rect[3]-0.1,"Scrolling body text leaves speaker and Continue in fixed separate areas")
	state.prefs.music=0.0;game.audio.apply();game.ui.show_dialogue(["Kurt: Sessiz tercih korunur.","Wolf: Keep the mute preference."]);await frames(20)
	check(game.audio.music.volume_linear==0.0 and state.prefs.music==0.0,"Muted music stays muted in dialogue")
	game.ui.close_panel();await frames(20);check(game.audio.music.volume_linear==0.0,"Closing dialogue never unmutes the player")
	var f=FileAccess.open("res://work/dialogue-audio-results.json",FileAccess.WRITE);f.store_string(JSON.stringify({"checks":checks,"snapshots":snapshots},"  "));f.close()
	var failures=checks.filter(func(c):return c.status=="FAIL");print("DIALOGUE/AUDIO: ",checks.size()," checks; failures ",failures)
	game.queue_free();await process_frame;quit(0 if failures.is_empty() else 1)
