extends CanvasLayer

# Path to the next scene to transition to
export var nextLevel : int = 1
var reload = false
# Reference to the _AnimationPlayer_ node
onready var _anim_player := $AnimationPlayer

func _ready():
	$ColorRect.color=Color(0,0,0,0)

func transition(Reload):
	reload=Reload
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("Fade")


func _on_AnimationPlayer_animation_finished(_anim_name):
	if reload:
		var _k = get_tree().reload_current_scene()
		return
	elif nextLevel >=10:
		var _k = get_tree().change_scene("res://TitleScreen.tscn")
		return
	var _k = get_tree().change_scene("res://src/World/Levels/L"+str(nextLevel)+".tscn")
