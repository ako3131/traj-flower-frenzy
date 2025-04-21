extends Node2D

func _ready():
	var sprite = $coco_animation  # Replace with your sprite's path
	var coco_label = $Label2
	sprite.animation = "idle"
	sprite.play()  # Start the animation
	coco_label.hide()
	
	# Get the sprite's width properly
	var sprite_width = 50
	
	# Create the tween sequence
	var tween = create_tween()
	
	# Move from left off-screen to center
	#sprite.position.x = -sprite_width
	#tween.tween_property(sprite, "position:x", (get_viewport_rect().size.x/6 * 2), 1.0)
	# Pause for 1 second
	tween.tween_interval(.5)
	
	tween.tween_callback(func(): 
		var effect = ShutterEffect.new()
		add_child(effect)
		effect.setup($hand)
		#effect.effect_completed.connect(_on_effect_completed)
		effect.play()
		$boss_die.play()
	)
	
	# Pause for 1 second
	tween.tween_interval(1.0)
	
	# Animation change at center
	tween.tween_callback(func(): 
		sprite.animation = "idle"
		sprite.play()
		coco_label.show()
	)
	
	# Pause for 1 second
	tween.tween_interval(2.0)
	
	# Animation change at center
	tween.tween_callback(func(): 
		coco_label.text = "I better get home now"
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
	tween.tween_property(sprite, "position:x", get_viewport_rect().size.x + sprite_width, 1.25)
	
	tween.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/end_scene.tscn")
	)
