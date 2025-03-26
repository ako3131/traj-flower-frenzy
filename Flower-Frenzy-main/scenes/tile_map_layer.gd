extends TileMapLayer


# In your TileMap script or scene setup
func _ready():
	set_collision_animatable(true)
	set_collision_use_parent(true)
	set_collision_layer(1)  # Put on your ground layer
	set_collision_mask(1)    # Collide with layer 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
