extends Node2D
onready var pause = preload("res://src/Menus/PauseMenu.tscn")
onready var death = preload("res://src/Menus/DeathMenu.tscn")
onready var _level_shifter = $LevelDetector
onready var changeLevel = $ScreenTransition
var num_players = 0
var changing=false
func _ready() -> void:
	_level_shifter.connect("body_entered", self, "_on_LevelDetector_body_entered")
	_level_shifter.connect("body_exited", self, "_on_LevelDetector_body_exited")


func _spawn(object):
	if !changing:
		var instance = object.instance()
		call_deferred("add_child",instance)

func _input(event):
	if !changing:
		if event.is_action_pressed("ui_cancel"):
			_spawn(pause)

# Restart level
func _on_LavaDetector_body_entered(body):
	if "Player" in body.name:
		_spawn(death)


func _on_LevelDetector_body_entered(body: Node) -> void:
	if "Player" in body.name:
		num_players += 1
		if num_players == 2:
			if !changing:
					changeLevel.transition(false)


func _on_LevelDetector_body_exited(_body: Node) -> void:
	num_players -= 1


func _on_Key_collected():
	pass # Replace with function body.
