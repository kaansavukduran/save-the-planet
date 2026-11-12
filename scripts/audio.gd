class_name PlanetAudio
extends Node
## Original procedural audio; no third-party samples.
var music: AudioStreamPlayer
var sfx: AudioStreamPlayer
func tone(freq: float,duration: float,volume: float=0.2) -> AudioStreamWAV:
	var stream=AudioStreamWAV.new();stream.format=AudioStreamWAV.FORMAT_16_BITS;stream.mix_rate=22050
	var bytes=PackedByteArray();bytes.resize(int(duration*22050)*2)
	for i in int(duration*22050):
		var envelope=minf(i/180.0,1.0)*maxf(0,1.0-i/(duration*22050))
		var v=int(sin(TAU*freq*i/22050.0)*envelope*volume*32767)
		bytes.encode_s16(i*2,v)
	stream.data=bytes;return stream
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_PAUSABLE
	music=AudioStreamPlayer.new();sfx=AudioStreamPlayer.new();add_child(music);add_child(sfx)
	var song=AudioStreamWAV.new();song.format=AudioStreamWAV.FORMAT_16_BITS;song.mix_rate=22050
	var data=PackedByteArray()
	for note in [261.63,329.63,392.0,329.63,293.66,349.23,440.0,349.23]:data.append_array(tone(note,0.5,0.07).data)
	song.data=data;song.loop_mode=AudioStreamWAV.LOOP_FORWARD;song.loop_end=data.size()/2
	music.stream=song;apply();music.play()
func apply() -> void:
	if music:music.volume_linear=float(State.prefs.music)
	if sfx:sfx.volume_linear=float(State.prefs.sfx)
func cue(success: bool=true) -> void:
	sfx.stream=tone(660 if success else 180,0.2);sfx.play()

func _exit_tree() -> void:
	# Release paused loop playback before the AudioServer shuts down.
	if is_instance_valid(music):music.stop();music.stream=null
	if is_instance_valid(sfx):sfx.stop();sfx.stream=null
