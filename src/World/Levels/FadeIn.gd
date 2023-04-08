extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	$ColorRect.color=Color(0,0,0,255)
	$AnimationPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(_anim_name):
	call_deferred("queue_free")
