extends Node2D

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_0.tscn")
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
