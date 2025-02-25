extends CharacterBody2D

@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0,1) var accerlation = 0.1
@export_range(0,1) var decelration = 0.1

@export var jump_force = -400.0
@export_range(0,1) var decelerate_on_jump_release = 0.5

@export var knock_back_strength = 100

var is_attacking = false
#Removed the in_are boolean
#Hit counter variables 
var hit_count: int = 0

var missed_swings: int = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release

	# Handle attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.play()
		# Enable hitbox for attack
		$AttackArea.monitoring = true
		
		# Check if attack hits an enemy
		var hit_registered = deal_damage()
		
		if hit_registered:
			hit_count += 1
			missed_swings = 0  # Reset missed count
		else:
			missed_swings += 1
			if missed_swings >= 3:
				hit_count = 0  # Reset hit count after 3 missed swings

		update_hit_display()  # Update UI
		return  # Prevent other animations from playing during attack
 

	# Handle movement only if not attacking
	if not is_attacking:
		var speed
		if Input.is_action_pressed("sprint"):
			speed = run_speed
		else:
			speed = walk_speed

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, speed * accerlation)
			$AnimatedSprite2D.flip_h = direction < 0
			if is_on_floor():
				$AnimatedSprite2D.animation = "walk"
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed * decelration)

		# Jump animation
		if not is_on_floor():
			$AnimatedSprite2D.animation = "jump"
		elif velocity.length() == 0:
			$AnimatedSprite2D.animation = "still"

	$AnimatedSprite2D.play()
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
		# Resume appropriate animation based on state
		if not is_on_floor():
			$AnimatedSprite2D.animation = "jump"
		elif velocity.length() == 0:
			$AnimatedSprite2D.animation = "still"
		else:
			$AnimatedSprite2D.animation = "walk"

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemy"):
		#enemy_in_range = true
		
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("enemy"):
		#enemy_in_range = false
		
func deal_damage() -> bool:
	var hit_registered = false
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			# Only change x direction
			hit_registered = true
			body.take_damage()
			var knock_back_direction = Vector2(body.global_position.x - global_position.x, 0).normalized()
			var knock_back = knock_back_direction * knock_back_strength
			body.global_position += knock_back
	update_hit_display()
	return hit_registered
	
func update_hit_display():
	var hit_display = get_node_or_null("/root/main/Combo") 
	if hit_display:
		hit_display.text = "COMBO: " + str(hit_count)
	else: 
		print("Error: NO COMBO found")
	
