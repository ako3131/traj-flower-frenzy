extends Node2D
#
## Textures for each level
#var level_textures: Array = [
	#preload("res://arts/flowers/flower_0.png"),
	#preload("res://arts/flowers/flower_1.png"),
	#preload("res://arts/flowers/flower_2.png")
#]
var flower_count

# Current level
var current_level = Globals.level

func _ready() -> void:
	pass
	#update_texture()
	
func _process(delta: float) -> void:
	$flower_1/label.text = "X" + str(Globals.flower_scores_list[1])
	$flower_2/label.text = "X" + str(Globals.flower_scores_list[2])
	$flower_3/label.text = "X" + str(Globals.flower_scores_list[3])

#func update_texture() -> void:
	# Ensure the level is within the array bounds
	#if current_level >= 0 and current_level < level_textures.size():
		#$Sprite2D.texture = level_textures[current_level]
		#$Sprite2D.scale = Vector2(7,7)
	#else:
		#print("Invalid level: ", current_level)
