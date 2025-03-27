extends Area2D

#func _ready() -> void:
	#$sparkles.emitting = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#$CollisionShape2D.disabled = true
		#$Sprite2D.visible = false
		#$sparkles.emitting = true
		#await get_tree().create_timer($sparkles.lifetime).timeout
		queue_free()
		Globals.flower_scores_list[Globals.level] += 1
		
