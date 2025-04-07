extends Node2D

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_into.tscn")
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1_opening.tscn")
	
func _on_start_Level2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_2_opening.tscn")
	
func _on_start_Level3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_3_opening.tscn")
	
func _physics_process(delta: float) -> void:
	$coco_animation.play()
