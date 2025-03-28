extends Node2D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	$Label.text = "X" + str(Globals.flower_scores_list[0])
