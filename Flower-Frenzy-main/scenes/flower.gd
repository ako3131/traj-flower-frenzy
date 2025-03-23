extends Sprite2D

# Textures for each level
var level_textures: Array = [
	preload("res://arts/flowers/flower_0.png"),
	preload("res://arts/flowers/flower_1.png")
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
