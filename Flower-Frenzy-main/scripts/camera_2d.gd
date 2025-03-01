extends Camera2D

@export var player: Node2D  # Reference to the player node
@export var smoothing_speed: float = 5.0  # Adjust this for smoother transitions
@export var y_offset: float = 100  # Adjusts camera height
@export var x_offset: float = 50  # Adjust this to shift the player left/right in the frame

var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player:
		position_smoothing_enabled = false  # We will handle smoothing manually
		offset = Vector2.ZERO  # Reset any default offsets
		drag_horizontal_enabled = false
		drag_vertical_enabled = false
		make_current()  # Ensure this camera is active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		# Define target position based on the player's location
		target_position = player.global_position
		target_position.x += x_offset  # Apply horizontal offset
		target_position.y -= y_offset  # Apply vertical offset

		# Smoothly move camera towards target position
		global_position = global_position.lerp(target_position, smoothing_speed * delta)
