extends CharacterBody2D

@export var speed = 150
@export var max_health = 80
@export var knockback_decay = 0.9  # How fast knockback fades (1 = no decay, 0 = instant stop)
@export var knockback_resistance = 0.15  # Higher = less knockback effect

var health = max_health
var player_position
var target_position
var knockback_velocity = Vector2.ZERO  # Knockback force storage
var is_knocked_back = false  # Flag for knockback state
@onready var player = get_parent().get_node("coco")

func _physics_process(delta: float) -> void:	
	# Get player position relative to self position
	player_position = player.global_position
	target_position = (player_position - self.global_position).normalized()

	# Flip if necessary
	$AnimatedSprite2D.flip_h = target_position.x > 0
	
	# Apply knockback smoothly
	if is_knocked_back:
		knockback_velocity *= knockback_decay
		if knockback_velocity.length() < 100:
			$AnimatedSprite2D.animation = "default"
		if knockback_velocity.length() < 1:
			knockback_velocity = Vector2.ZERO
			is_knocked_back = false  # Stop knockback

	if position.distance_to(player_position) < 300 and not is_knocked_back:
		velocity = target_position * speed + knockback_velocity  # Normal movement + knockback
	else:
		velocity = knockback_velocity  # Apply knockback when idle
		
	$AnimatedSprite2D.play()
	move_and_slide()

func apply_knockback(force: Vector2, hit_strength: int) -> void:
	# Apply knockback based on resistance
	knockback_velocity = force * (1 - knockback_resistance)  
	is_knocked_back = true
	
	# Show hit animation
	$AnimatedSprite2D.animation = "hit"

	# Reduce health
	health -= hit_strength
	if health <= 0:
		queue_free()
