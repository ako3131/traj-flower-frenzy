extends Node2D
	
	
func _physics_process(delta: float) -> void:
	$bug_monster.play()
	$bug_monster2.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
