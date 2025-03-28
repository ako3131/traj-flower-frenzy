extends CharacterBody2D

@export var walk_speed = 350.0
@export var run_speed = 450.0
@export_range(0,1) var accerlation = 0.1
@export_range(0,1) var decelration = 0.1

@export var jump_force = -470.0
@export_range(0,1) var decelerate_on_jump_release = 0.5

@export var knock_back_strength = 150  # Strength of knockback applied to enemies
@export var hit_strength = 20  # Damage per hit

@export var max_health = 100
var health = max_health
var always_show_health = true

var is_attacking = false
var hit_count: int = 0
var missed_swings: int = 0

var power_up_enabled = false

var lives = 3
var enemy_hit = false

var player_getting_hit = false
var total_player_damage = 0

var power_up_thresholds: Array = [
	3,
	8,
	10
]

func _ready() -> void:
	if Globals.level == 0:
		$flower_counter.hide()
		$tutorial_flower_counter.show()
	else:
		$flower_counter.show()
		$tutorial_flower_counter.hide()

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release
		
	# Handle power up attack
	if power_up_enabled and Input.is_action_just_pressed("power_attack"):
		$PowerAttackArea.monitoring = true
		$Flower.power_up_animation()
		print("power attack button pressed")
		return
	
	if Input.is_action_just_released("power_attack"):
		close_power_up()
		
	if Input.is_action_just_released("attack"):
		if enemy_hit:
			hit_count += 1
			$combo_label.update_combo()
			set_power_up()
			enemy_hit = false
			
	#if player_getting_hit:
		#take_damage(total_player_damage)

	# Handle attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.play()
		# Enable hitbox for attack
		$AttackArea.monitoring = true
		
		# Check if attack hits an enemy
		#var hit_registered = deal_damage()
		
		#if hit_registered:
			#hit_count += 1
			#missed_swings = 0  # Reset missed count
		#else:
			#missed_swings += 1
			#if missed_swings >= 1:
				#hit_count = 0  # Reset hit count after 3 missed swings

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
		if not is_on_floor() or velocity.length() == 0:
			$AnimatedSprite2D.animation = "idle"
			
	$AnimatedSprite2D.play()
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
		$AttackArea.monitoring = false
		# Resume appropriate animation based on state
		if not is_on_floor() or velocity.length() == 0:
			$AnimatedSprite2D.animation = "idle"
		else:
			$AnimatedSprite2D.animation = "walk"
		
@export var knock_back_distance = 4  # Adjust this to control knockback distance
#
#func deal_damage() -> bool:
	#var hit_registered = false
	#var bodies = $AttackArea.get_overlapping_bodies()
	#for body in bodies:
		#if body.is_in_group("enemy"):
			#hit_registered = true
#
			## Knockback calculation (now includes knock_back_distance multiplier)
			#var knock_back_direction = Vector2(body.global_position.x - global_position.x, 0).normalized()
			#var knock_back = knock_back_direction * knock_back_strength * knock_back_distance
#
			## Apply knockback smoothly by calling enemy's `apply_knockback` method
			#if body.has_method("apply_knockback"):
				#body.apply_knockback(knock_back, hit_strength)  # Pass both values
#
	#return hit_registered

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	if Globals.level != 0 and Globals.level <= Globals.max_level:
		$next_level.next_level()
	else:
		game_over()
	
func respawn():
	$lives_label.update_lives()
	await get_tree().create_timer(.4).timeout  # Delay so health bar shows depleted
	health = max_health
	position = Vector2(551, 482)
	
func game_over():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func set_power_up():
	print("check power up", hit_count)
	var thresh = power_up_thresholds[Globals.level]
	if hit_count >= thresh:
		print("power up enabled")
		power_up_enabled = true
		$combo_label.make_label_red()
		
func close_power_up():
	print("power up closed")
	power_up_enabled = false
	hit_count = 0
	$PowerAttackArea.monitoring = false
	$combo_label.make_label_white()
	$combo_label.update_combo()
	
#func update_hit_display():
	#var hit_display = get_node_or_null("/root/main/Combo") 
	#if hit_display:
		#hit_display.text = "COMBO: " + str(hit_count)
	##else: 
		##print("Error: NO COMBO found")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_hit = true
		#hit_count += 1
		# Knockback calculation (now includes knock_back_distance multiplier)
		var knock_back_direction = Vector2(body.global_position.x - global_position.x, 0).normalized()
		var knock_back = knock_back_direction * knock_back_strength * knock_back_distance

		# Apply knockback smoothly by calling enemy's `apply_knockback` method
		if body.has_method("apply_knockback"):
			body.apply_knockback(knock_back, hit_strength)  # Pass both values
		#$combo_label.update_combo()
		#set_power_up()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		take_damage(body.power)	
		total_player_damage += body.power

func _on_power_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("power attacked enemy")
		# Knockback calculation (now includes knock_back_distance multiplier)
		var knock_back_direction = Vector2(body.global_position.x - global_position.x, 0).normalized()
		var knock_back = knock_back_direction * knock_back_strength * knock_back_distance

		# Apply knockback smoothly by calling enemy's `apply_knockback` method
		if body.has_method("apply_knockback"):
			body.apply_knockback(knock_back, hit_strength * 2)  # Pass both values
		close_power_up()
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fall_area"):
		take_damage(health)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		total_player_damage -= body.power


func _on_hit_timer_timeout() -> void:
	take_damage(total_player_damage)
