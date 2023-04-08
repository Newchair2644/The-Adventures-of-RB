extends AudioStreamPlayer


var bg_music = load("res://assets/sounds/615745__rap2h__charlette-320-ternary.wav")


func play_music(var _path: String) -> void:
	$Music.stream = bg_music
	$Music.play()
