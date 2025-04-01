extends Node2D
	
func _ready() -> void:
	# reset score
	for i in range(len(Globals.flower_scores_list)):
		Globals.flower_scores_list[i] = 0
		
	$game_over_sound.play()
	
func _physics_process(delta: float) -> void:
	$bug_monster.play()
	$bug_monster2.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1_opening.tscn")
