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

# Time slow ability variables
var time_slow_enabled = false
var time_slow_active = false
var time_slow_duration = 1.0  # Duration in seconds
var time_slow_timer = 0.0
var time_slow_factor = 0.3  # How much to slow down time (lower = slower)
var time_slow_cost = 10  # Hit streak cost

# Tornado Slash ability variables
var tornado_slash_enabled = true  # Whether the ability is available
var tornado_slash_active = false  # Whether the ability is currently active
var tornado_slash_duration = 2.0  # Duration in seconds
var tornado_slash_timer = 0.0  # Current timer for the ability
var tornado_slash_charge_time = 1.0  # Time needed to hold K to activate
var tornado_slash_charge_timer = 0.0  # Current charge timer
var tornado_slash_charging = false  # Whether currently charging the ability
var tornado_slash_damage_interval = 0.2  # How often to apply damage during spin
var tornado_slash_damage_timer = 0.0  # Timer for damage application
var tornado_slash_rotation_speed = 15.0  # How fast to rotate during spin

var enemy_hit = false

var player_getting_hit = false
var total_player_damage = 0

var fall_damage_power = 30

var power_up_thresholds: Array = [
	3,
	5,
	5,
	5
]

@onready var player_marker = get_parent().get_node("player_marker")

func _ready() -> void:
	# Reset all game state variables when the scene loads
	reset_game_state()
	
	if Globals.level == 0:
		$flower_counter.hide()
		$tutorial_flower_counter.show()
	else:
		$flower_counter.show()
		$tutorial_flower_counter.hide()
	
	# set up sound effects
	#$power_up_sound.volume_db = 0.0  # Reset volume
	#$power_up_sound.pitch_scale = 1.0  # Reset pitch
	$power_up_sound.stop()  # Stop any previous playback
	
	# set up sound effects
	#$hit_sound.volume_db = 0.0  # Reset volume
	#$hit_sound.pitch_scale = 1.0  # Reset pitch
	$hit_sound.stop()  # Stop any previous playback
	
	# Create hitstop node for combat feedback
	var hitstop_node = Hitstop.new()
	hitstop_node.name = "Hitstop"
	add_child(hitstop_node)
	hitstop_node.hitstop_completed.connect(_on_hitstop_completed)
	
	#$hit_effect.play

func _physics_process(delta: float) -> void:
	if hit_count >= power_up_thresholds[Globals.level]:
		$Flower.show()
	else:
		$Flower.hide()
	# Adjust delta for time slow effect
	var adjusted_delta = delta
	if time_slow_active:
		adjusted_delta = delta / time_slow_factor
	
	# Add gravity
	if not is_on_floor():
		velocity += calculate_gravity() * adjusted_delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release
		
	# Handle time slow ability
	if Input.is_action_just_pressed("time_slow"):
		# If already active, deactivate first
		if time_slow_active:
			deactivate_time_slow()
		# Then check if we can activate it again
		elif hit_count >= time_slow_cost:
			activate_time_slow()
		
	# Update time slow effect if active
	if time_slow_active:
		time_slow_timer -= delta # Use regular delta instead of adjusted_delta
		print("Time slow timer: ", time_slow_timer)
		if time_slow_timer <= 0:
			deactivate_time_slow()
			
	# Handle Tornado Slash ability
	if tornado_slash_enabled:
		# Start charging when H is pressed
		if Input.is_action_pressed("tornado_slash") and not is_attacking and not tornado_slash_active:
			tornado_slash_charging = true
			tornado_slash_charge_timer += delta
			
			# Activate when charged enough
			if tornado_slash_charge_timer >= tornado_slash_charge_time:
				activate_tornado_slash()
				tornado_slash_charging = false
				tornado_slash_charge_timer = 0.0
		
		# Reset charge when H is released
		if Input.is_action_just_released("tornado_slash") and tornado_slash_charging:
			tornado_slash_charging = false
			tornado_slash_charge_timer = 0.0
		
		# Update tornado slash if active
		if tornado_slash_active:
			# Update timer
			tornado_slash_timer -= delta
			if tornado_slash_timer <= 0:
				deactivate_tornado_slash()
				return
			
			# Rotate player during spin
			rotation_degrees += tornado_slash_rotation_speed
			
			# Apply damage at intervals
			tornado_slash_damage_timer -= delta
			if tornado_slash_damage_timer <= 0:
				apply_tornado_slash_damage()
				tornado_slash_damage_timer = tornado_slash_damage_interval
			
			# Keep attack animation playing
			if $AnimatedSprite2D.animation != "attack":
				$AnimatedSprite2D.animation = "attack"
				$hit_effect.show()
			
			return  # Skip other processing while spinning

	# Handle power up attack
	if power_up_enabled and Input.is_action_just_pressed("power_attack"):
		$PowerAttackArea.monitoring = true
		#$Flower.power_up_animation()
		print("power attack button pressed")
		$power_up_sound.play()
		# Wait for sound to finish before freeing
		await $power_up_sound.finished
		return

	if Input.is_action_just_released("power_attack"):
		close_power_up()
		
	if Input.is_action_just_released("attack"):
		$sword_sound.play()
		if enemy_hit:
			$hit_sound.play()
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
		$hit_effect.show()
		$hit_effect.play()
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
			if not $run_sound.playing:
				$run_sound.play()
			$walk_sound.stop()  # Stop walk sound if running
		else:
			speed = walk_speed
			if velocity != Vector2(0,0):
				if not $walk_sound.playing:
					$walk_sound.play()
			$run_sound.stop()  # Stop run sound if walking

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, speed * accerlation)
			$AnimatedSprite2D.flip_h = direction < 0
			$hit_effect.flip_h = direction < 0
			if is_on_floor():
				$AnimatedSprite2D.animation = "walk"
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed * decelration)

		# Jump animation
		if not is_on_floor() or velocity.length() == 0:
			$run_sound.stop()
			$walk_sound.stop()
			$AnimatedSprite2D.animation = "idle"
			
	$AnimatedSprite2D.play()
	move_and_slide()

# Add this function to handle gravity calculations
func calculate_gravity() -> Vector2:
	return Vector2(0, 980)  # Standard gravity value in Godot

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack" and not tornado_slash_active:
		is_attacking = false
		$AttackArea.monitoring = false
		print("hiding hit effect")
		$hit_effect.hide()
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
	game_over()
	
#func respawn():
	#$lives_label.update_lives()
	#await get_tree().create_timer(.4).timeout  # Delay so health bar shows depleted
	#health = max_health
	#position = Vector2(551, 482)
	
func game_over():
	# Ensure time scale is reset before changing scene
	if time_slow_active:
		deactivate_time_slow()
	
	# Reset game state before changing scene
	reset_game_state()
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func set_power_up():
	var thresh = power_up_thresholds[Globals.level]
	if hit_count >= thresh:
		power_up_enabled = true
		$combo_label.make_label_red()
		
func close_power_up():
	power_up_enabled = false
	hit_count = 0
	#if (hit_count - power_up_thresholds[Globals.level]) < 0:
		#hit_count = 0
	#else:
		#hit_count -= power_up_thresholds[Globals.level]
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
			
		# Trigger hitstop for impact feedback
		if has_node("Hitstop"):
			var hitstop = get_node("Hitstop")
			hitstop.start()
		#$combo_label.update_combo()
		#set_power_up()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		$player_hit_sound.play()
		take_damage(body.power)	
		total_player_damage += body.power

func _on_power_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		# Knockback calculation (now includes knock_back_distance multiplier)
		var knock_back_direction = Vector2(body.global_position.x - global_position.x, 0).normalized()
		var knock_back = knock_back_direction * knock_back_strength * knock_back_distance

		# Apply knockback smoothly by calling enemy's `apply_knockback` method
		if body.has_method("apply_knockback"):
			body.apply_knockback(knock_back, hit_strength * 2)  # Pass both values
			
		# Trigger hitstop for power attacks (same duration as normal attacks)
		if has_node("Hitstop"):
			var hitstop = get_node("Hitstop")
			hitstop.start()
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fall_area"):
		take_damage(fall_damage_power)
		position = player_marker.position


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		total_player_damage -= body.power


func _on_hitstop_completed() -> void:
	pass

func _on_hit_timer_timeout() -> void:
	take_damage(total_player_damage)


func activate_time_slow() -> void:
	# Consume hit streak
	hit_count -= time_slow_cost
	$combo_label.update_combo()
	
	# Activate time slow effect
	time_slow_active = true
	time_slow_timer = time_slow_duration
	
	# Apply time slow effect to everything except player
	Engine.time_scale = time_slow_factor
	
	# Set player to not be affected by time scale
	process_mode = Node.PROCESS_MODE_ALWAYS
	$AnimatedSprite2D.process_mode = Node.PROCESS_MODE_ALWAYS
	$hit_effect.process_mode = Node.PROCESS_MODE_ALWAYS
	$AttackArea.process_mode = Node.PROCESS_MODE_ALWAYS
	$PowerAttackArea.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0.7, 0.7, 1.5, 1.0), 0.3)
	
	# Play sound effect (you can add a sound node and uncomment this)
	# $time_slow_sound.play()
	
	print("Time slow activated")
	
	# Removed velocity adjustment to keep player movement normal
	# The line below was causing the player to be affected by time slow
	# velocity = velocity / time_slow_factor
	
	# Create a timer to ensure deactivation after duration
	var timer = get_tree().create_timer(time_slow_duration)
	timer.timeout.connect(func(): if time_slow_active: deactivate_time_slow())


func deactivate_time_slow() -> void:
	# Reset time scale
	Engine.time_scale = 1.0
	time_slow_active = false
	
	# Reset process mode for player and components
	process_mode = Node.PROCESS_MODE_INHERIT
	$AnimatedSprite2D.process_mode = Node.PROCESS_MODE_INHERIT
	$hit_effect.process_mode = Node.PROCESS_MODE_INHERIT
	$AttackArea.process_mode = Node.PROCESS_MODE_INHERIT
	$PowerAttackArea.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	
	print("Time slow deactivated")


func activate_tornado_slash() -> void:
	# Activate tornado slash effect
	tornado_slash_active = true
	tornado_slash_timer = tornado_slash_duration
	tornado_slash_damage_timer = 0.0  # Apply damage immediately
	
	# Set up attack state
	is_attacking = true
	$AnimatedSprite2D.animation = "attack"
	$AnimatedSprite2D.play()
	$hit_effect.show()
	$AttackArea.monitoring = true
	
	# Play sound effect
	$sword_sound.play()
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.2, 0.8, 0.8, 1.0), 0.3)
	
	print("Tornado slash activated")


func deactivate_tornado_slash() -> void:
	# Reset tornado slash state
	tornado_slash_active = false
	rotation_degrees = 0  # Reset rotation
	
	# Reset attack state
	is_attacking = false
	$AttackArea.monitoring = false
	$hit_effect.hide()
	
	# Resume appropriate animation based on state
	if not is_on_floor() or velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "walk"
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	
	print("Tornado slash deactivated")


func apply_tornado_slash_damage() -> void:
	# Get all enemies in range
	var bodies = $AttackArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			# Calculate knockback in all directions (360 degrees)
			var knock_back_direction = (body.global_position - global_position).normalized()
			var knock_back = knock_back_direction * knock_back_strength * knock_back_distance
			
			# Apply knockback and damage
			if body.has_method("apply_knockback"):
				body.apply_knockback(knock_back, hit_strength)
				
			# Trigger hitstop for impact feedback
			if has_node("Hitstop"):
				var hitstop = get_node("Hitstop")
				hitstop.start()
				
			# Play hit sound
			$hit_sound.play()


func reset_game_state() -> void:
	# Reset combat stats
	is_attacking = false
	hit_count = 0
	missed_swings = 0
	enemy_hit = false
	player_getting_hit = false
	total_player_damage = 0
	
	# Reset power-up state
	power_up_enabled = false
	$PowerAttackArea.monitoring = false
	
	# Reset time slow ability
	if time_slow_active:
		deactivate_time_slow()
	time_slow_timer = 0.0
	
	# Reset tornado slash ability
	if tornado_slash_active:
		deactivate_tornado_slash()
	tornado_slash_charging = false
	tornado_slash_charge_timer = 0.0
	tornado_slash_timer = 0.0
	tornado_slash_damage_timer = 0.0
	
	# Reset health if needed (depending on level design)
	health = max_health
	
	# Reset visual states
	rotation_degrees = 0
	modulate = Color(1, 1, 1, 1)
	
	# Reset animation state
	$AnimatedSprite2D.animation = "idle"
	$hit_effect.hide()
	
	# Reset attack area
	$AttackArea.monitoring = false
	
	# Reset process mode
	process_mode = Node.PROCESS_MODE_INHERIT
	$AnimatedSprite2D.process_mode = Node.PROCESS_MODE_INHERIT
	$hit_effect.process_mode = Node.PROCESS_MODE_INHERIT
	$AttackArea.process_mode = Node.PROCESS_MODE_INHERIT
	$PowerAttackArea.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Ensure Engine time scale is reset
	Engine.time_scale = 1.0
	
	# Stop all sounds
	$power_up_sound.stop()
	$hit_sound.stop()
	$sword_sound.stop()
	$walk_sound.stop()
	$run_sound.stop()
	$player_hit_sound.stop()


#func _on_hit_effect_animation_finished() -> void:
	##if not tornado_slash_active:
		#is_attacking = false
		#$AttackArea.monitoring = false
		#$hit_effect.hide()
		## Resume appropriate animation based on state
		#if not is_on_floor() or velocity.length() == 0:
			#$AnimatedSprite2D.animation = "idle"
		#else:
			#$AnimatedSprite2D.animation = "walk"
