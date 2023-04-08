extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/MarginContainer/VBoxContainer/Play.grab_focus()
func _on_Play_pressed():
	$ScreenTransition.transition(false)


func _on_Quit_Game_pressed():
	get_tree().quit()
