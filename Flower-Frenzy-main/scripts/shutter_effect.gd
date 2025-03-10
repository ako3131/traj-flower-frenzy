class_name ShutterEffect
extends Node

signal effect_completed

var sprite: AnimatedSprite2D
var tween: Tween
var duration: float = 0.5

func setup(target_sprite: AnimatedSprite2D) -> void:
	sprite = target_sprite

# Play the shutter effect by modulating the sprite
func play() -> void:
	if sprite:
		tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, duration)
		await tween.finished
		emit_signal("effect_completed")
		queue_free()  # Clean up the effect node after completion
