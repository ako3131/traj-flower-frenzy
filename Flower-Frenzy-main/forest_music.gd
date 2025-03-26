extends AudioStreamPlayer

func _ready():
	# Ensure the audio plays and loops
	play()
	finished.connect(_on_audio_finished)

func _on_audio_finished():
	# Restart playback when the audio finishes
	play()
