extends Sprite
signal collected

func _on_Area2D_body_entered(_body: KinematicBody2D) -> void:
	emit_signal("collected")
	call_deferred("queue_free")

