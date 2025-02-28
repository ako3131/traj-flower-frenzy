extends CharacterBody2D

@export var speed = 30
@export var max_health = 60
@export var knockback_decay = 0.9  # How fast knockback fades (1 = no decay, 0 = instant stop)
@export var knockback_resistance = 0.2  # Higher = less knockback effect

var health = max_health
var player_position
var target_position
var knockback_velocity = Vector2.ZERO  # Knockback force storage
var is_knocked_back = false  # Flag for knockback state
@onready var player = get_parent().get_node("coco")

func _physics_process(delta: float) -> void:	
	# Handle gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get player position relative to self position
	player_position = player.global_position
	target_position = (player_position - self.global_position).normalized()

	# Flip if necessary
	$AnimatedSprite2D.flip_h = target_position.x > 0
	
	# Apply knockback smoothly
	if is_knocked_back:
		knockback_velocity *= knockback_decay
		if knockback_velocity.length() < 1:
			knockback_velocity = Vector2.ZERO
			is_knocked_back = false  # Stop knockback

	if is_on_floor():
		if position.distance_to(player_position) < 300 and not is_knocked_back:
			velocity = target_position * speed + knockback_velocity  # Normal movement + knockback
			$AnimatedSprite2D.animation = "walk"
		else:
			velocity = knockback_velocity  # Apply knockback even when idle
			$AnimatedSprite2D.animation = "still"
		
	$AnimatedSprite2D.play()
	move_and_slide()

func apply_knockback(force: Vector2, hit_strength: int) -> void:
	# Apply knockback based on resistance
	knockback_velocity = force * (1 - knockback_resistance)  
	is_knocked_back = true

	# Reduce health
	health -= hit_strength
	if health <= 0:
		queue_free()
