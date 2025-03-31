extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lab_1 = $flower_1/label
	var lab_2 = $flower_2/label
	var lab_3 = $flower_3/label
	
	lab_1.text = "X" + str(Globals.flower_scores_list[1])
	lab_2.text = "X" + str(Globals.flower_scores_list[2])
	lab_3.text = "X" + str(Globals.flower_scores_list[3])


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
