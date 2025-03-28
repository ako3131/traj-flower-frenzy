extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		Globals.flower_scores_list[Globals.level] += 1
