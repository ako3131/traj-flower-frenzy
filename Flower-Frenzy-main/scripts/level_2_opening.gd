extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	present()

func present():
	$Label2.modulate.a = 0  # Start transparent

	# Fade in animation
	var tween = create_tween()
	tween.tween_property($Label2, "modulate:a", 1.0, .5)
	await tween.finished

	# Wait a moment (optional)
	await get_tree().create_timer(1.5).timeout  # Adjust time as needed

	# Fade out animation
	tween = create_tween()
	tween.tween_property($Label2, "modulate:a", 0.0, .5)
	await tween.finished
	
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
