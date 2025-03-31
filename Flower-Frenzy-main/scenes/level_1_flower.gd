extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		##$CollisionShape2D.disabled = true
		##$Sprite2D.visible = false
		##$sparkles.emitting = true
		##await get_tree().create_timer($sparkles.lifetime).timeout
		#queue_free()
		#Globals.flower_scores_list[Globals.level] += 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# 1. Verify the node structure
		print("Sound node valid: ", $collect_sound != null)
		print("Sound stream: ", $collect_sound.stream)
		print("Sound bus: ", $collect_sound.bus)

		# 2. Force sound configuration
		$collect_sound.volume_db = 0.0  # Reset volume
		$collect_sound.pitch_scale = 1.0  # Reset pitch
		$collect_sound.stop()  # Stop any previous playback

		# 3. Play with error checking
		print("Attempting to play sound...")
		$collect_sound.play()

		# Hide visuals but keep node alive
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false

		# Wait for sound to finish before freeing
		await $collect_sound.finished

		# 5. Continue with your logic
		Globals.flower_scores_list[Globals.level] += 1
		queue_free()
