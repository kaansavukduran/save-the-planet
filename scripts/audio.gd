class_name PlanetAudio
extends Node
## Original procedural audio; no third-party samples.
var music: AudioStreamPlayer
var sfx: AudioStreamPlayer
var dialogue_active=false
var volume_tween: Tween
const DIALOGUE_GAIN=0.65
func tone(freq: float,duration: float,volume: float=0.2) -> AudioStreamWAV:
	var stream=AudioStreamWAV.new();stream.format=AudioStreamWAV.FORMAT_16_BITS;stream.mix_rate=22050
	var bytes=PackedByteArray();bytes.resize(int(duration*22050)*2)
	for i in int(duration*22050):
		var envelope=minf(i/180.0,1.0)*maxf(0,1.0-i/(duration*22050))
		var v=int(sin(TAU*freq*i/22050.0)*envelope*volume*32767)
		bytes.encode_s16(i*2,v)
	stream.data=bytes;return stream
func _ready() -> void:
	# Reading a dialogue pauses the world, not the soundtrack or UI feedback.
	process_mode=Node.PROCESS_MODE_ALWAYS
	music=AudioStreamPlayer.new();sfx=AudioStreamPlayer.new();add_child(music);add_child(sfx)
	var song=AudioStreamWAV.new();song.format=AudioStreamWAV.FORMAT_16_BITS;song.mix_rate=22050
	var data=PackedByteArray()
	for note in [261.63,329.63,392.0,329.63,293.66,349.23,440.0,349.23]:data.append_array(tone(note,0.5,0.07).data)
	song.data=data;song.loop_mode=AudioStreamWAV.LOOP_FORWARD;song.loop_end=data.size()/2
	music.stream=song;apply();music.play()
func apply() -> void:
	if volume_tween and volume_tween.is_valid():volume_tween.kill()
	if music:music.volume_linear=music_target()
	if sfx:sfx.volume_linear=float(State.prefs.sfx)
func music_target() -> float:
	return float(State.prefs.music)*(DIALOGUE_GAIN if dialogue_active else 1.0)
func set_dialogue(active: bool) -> void:
	if dialogue_active==active:return
	dialogue_active=active
	if not music:return
	if volume_tween and volume_tween.is_valid():volume_tween.kill()
	volume_tween=create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	volume_tween.tween_property(music,"volume_linear",music_target(),0.22)
func cue(success: bool=true) -> void:
	sfx.stream=tone(660 if success else 180,0.2);sfx.play()

func _exit_tree() -> void:
	if volume_tween and volume_tween.is_valid():volume_tween.kill()
	# Release paused loop playback before the AudioServer shuts down.
	if is_instance_valid(music):music.stop();music.stream=null
	if is_instance_valid(sfx):sfx.stop();sfx.stream=null
