extends Sprite2D

# Textures for each level
var level_textures: Array = [
	preload("res://arts/flowers/flower_0.png"),
	preload("res://arts/flowers/flower_1.png"),
	preload("res://arts/flowers/flower_2.png")
]

# Current level
var current_level = Globals.level

func _ready() -> void:
	update_texture()

func update_texture() -> void:
	print("current levle", current_level)
	print("glpobal lebel", Globals.level)
	# Ensure the level is within the array bounds
	if current_level >= 0 and current_level < level_textures.size():
		texture = level_textures[current_level]
	else:
		print("Invalid level: ", current_level)
		
func power_up_animation():
	var original_position = position
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position", original_position + Vector2(0, -100), 0.1)
	tween.tween_property(self, "scale", Vector2(20, 20), 0.5)
	tween.tween_property(self, "scale", Vector2(7, 7), 0.25)
	tween.tween_property(self, "position", original_position, 0.1)
