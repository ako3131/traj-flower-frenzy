extends Node2D

# Textures for each level
var level_textures: Array = [
	preload("res://arts/flowers/flower_0.png"),
	preload("res://arts/flowers/flower_1.png"),
	preload("res://arts/flowers/flower_2.png")
]
var flower_count

# Current level
var current_level = Globals.level

func _ready() -> void:
	update_texture()
	
func _process(delta: float) -> void:
	flower_count = Globals.flower_scores_list[Globals.level]
	$Label.text = "X" + str(flower_count)

func update_texture() -> void:
	# Ensure the level is within the array bounds
	if current_level >= 0 and current_level < level_textures.size():
		$Sprite2D.texture = level_textures[current_level]
		$Sprite2D.scale = Vector2(7,7)
	else:
		print("Invalid level: ", current_level)
