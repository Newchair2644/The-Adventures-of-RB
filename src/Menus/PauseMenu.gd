extends CanvasLayer

func _ready():
	$"Pause Menu/CenterContainer/MarginContainer/VBoxContainer/Play2".grab_focus()
	get_tree().paused=true
func _on_Play2_pressed():
	get_parent().changing = true
	get_tree().paused=false
	get_parent().changeLevel.transition(true)


func _on_Play_pressed():
	get_parent().changing = false
	get_tree().paused=false
	call_deferred("queue_free")


func _on_Quit_Game_pressed():
	get_tree().paused=false
	get_tree().quit()
