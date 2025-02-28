extends CharacterBody2D

@export var speed = 50
var player_position
var target_position
@onready var player = get_parent().get_node("coco")
@export var max_health = 40
var health = max_health
func _physics_process(delta: float) -> void:	
	
	# Get player position in respect to self position
	player_position = player.global_position
	target_position = (player_position - self.global_position).normalized()

	# Flip if necessary
	$AnimatedSprite2D.flip_h = target_position.x > 0
	
	if position.distance_to(player_position) < 300:
		velocity = target_position * speed
	else:
		velocity = Vector2(0,0)
		
	$AnimatedSprite2D.play()
	
	move_and_slide()
	
func take_damage(player_pos: Vector2, knock_back_strength: float, hit_strength: float):
	var knock_back_direction = Vector2(position.x - player_pos.x, -400).normalized()
	var knock_back = knock_back_direction * (knock_back_strength)
	position += knock_back
	health -= hit_strength
	if health <= 0:
		queue_free()
