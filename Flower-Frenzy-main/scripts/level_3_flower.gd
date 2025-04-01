extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Globals.flower_scores_list[Globals.level] += 1
		$CollisionShape2D.hide()
		$collect_sound.stop()  # Stop any previous playback

		$collect_sound.play()

		# Hide visuals but keep node alive
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false

		# Wait for sound to finish before freeing
		await $collect_sound.finished

		queue_free()
