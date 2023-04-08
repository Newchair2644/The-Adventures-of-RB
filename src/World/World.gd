extends Node2D


onready var _current_level = $CurrentLevel
onready var _transition_rect = $ScreenTransition


func _ready() -> void:
	pass
	

# Switching between fullscreen and not fullscreen
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		OS.window_fullscreen = false
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func _on_CurrentLevel_level_changed(level_index: int) -> void:
	var next_level_scene = "res://src/World/Levels/L%d.tscn" % (level_index + 1)
	_transition_rect.transition_to(next_level_scene)
