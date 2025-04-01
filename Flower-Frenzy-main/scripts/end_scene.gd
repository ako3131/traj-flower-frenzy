extends Node2D

func _ready():
	var sprite = $coco_animation  # Replace with your sprite's path
	sprite.animation = "run"
	sprite.play()  # Start the animation
	
	# Get the sprite's width properly
	var sprite_width = 50
	
	# Create the tween sequence
	var tween = create_tween()
	
	# Move from left off-screen to center
	sprite.position.x = -sprite_width
	tween.tween_property(sprite, "position:x", (get_viewport_rect().size.x/3 * 2), 2.0)
	
	tween.tween_callback(sprite.queue_free)
	
	tween.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/score_scene.tscn")
	)
