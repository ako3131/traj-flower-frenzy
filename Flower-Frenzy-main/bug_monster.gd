extends CharacterBody2D

@export var speed = 25
var player_position
var target_position
@onready var player = get_parent().get_node("coco")

func _physics_process(delta: float) -> void:	
	if not is_on_floor():
		velocity += get_gravity() * delta

	player_position = player.global_position
	target_position = (player_position - self.global_position).normalized()
	
	if is_on_floor():
		if position.distance_to(player_position) < 500:
			velocity = target_position * speed
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = velocity.x > 0
		else:
			velocity = Vector2(0,0)
			$AnimatedSprite2D.animation = "still"
		
	$AnimatedSprite2D.play()	
	move_and_slide()
