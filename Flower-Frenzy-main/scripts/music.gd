extends Node2D

@onready var audio_player = $AudioStreamPlayer2D

func _ready():
	# Ensure the audio plays and loops
	audio_player.play()
	audio_player.finished.connect(_on_audio_finished)

func _on_audio_finished():
	# Restart playback when the audio finishes
	audio_player.play()
