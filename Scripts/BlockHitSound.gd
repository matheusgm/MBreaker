extends AudioStreamPlayer

var audio_type
signal audio_finished

func _ready():
	pass


func play_sound_hit(audio):
	audio_type = 0
	set_stream(audio)
	play()

func play_sound_destroy(audio):
	audio_type = 1
	set_stream(audio)
	play()
	
func _on_AudioStreamPlayer_finished():
	if audio_type == 0:
		queue_free()
	else:
		emit_signal("audio_finished")
	pass
