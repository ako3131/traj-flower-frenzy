extends Node2D

func _ready():
	var sprite = $coco_animation  # Replace with your sprite's path
	var coco_label = $Label2
	sprite.animation = "run"
	sprite.play()  # Start the animation
	coco_label.hide()
	
	# Get the sprite's width properly
	var sprite_width = 50
	
	# Create the tween sequence
	var tween = create_tween()
	
	# Move from left off-screen to center
	sprite.position.x = -sprite_width
	tween.tween_property(sprite, "position:x", (get_viewport_rect().size.x/3 * 2), 2.0)
	
	# Animation change at center
	tween.tween_callback(func(): 
		sprite.animation = "idle"
		sprite.flip_h = true
		sprite.play()
		coco_label.show()
	)
	
	# Pause for 1 second
	tween.tween_interval(2.0)
	
	# Prepare to exit
	tween.tween_callback(func():
		sprite.animation = "run"
		sprite.flip_h = false
		sprite.play()
		coco_label.hide()
	)
	
	# Move from center to right off-screen
	tween.tween_property(sprite, "position:x", get_viewport_rect().size.x + sprite_width, .5)
	
	tween.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/level_0.tscn")
	)
