extends StaticBody2D

func _on_Key_collected() -> void:
	$AnimationPlayer.play("Fade")


func _on_AnimationPlayer_animation_finished(_anim_name):
	call_deferred("queue_free")
