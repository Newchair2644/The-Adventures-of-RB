extends Actor

# groundpound code
onready var poundTimer = $poundTimer
var pound_velocity := -(jump_height) / jump_time_to_peak 
var pound_direction = Vector2(0,1)


var momentum = false
func _input(event):
	#if the pound button timer is pressed , and the player can pound (is on hook)
	#then we start the pound holding button timer
	if event.is_action_pressed("p2_down") and can_pound:
		_animated_sprite.speed_scale = 1.00
		_animated_sprite.play("ground pound")
		_animated_sprite.playing=true
		momentum = true
		poundTimer.start()
	if event.is_action_released("p2_down") :
		if can_pound and momentum:
			pound_velocity *= (4-poundTimer.time_left)
			_pound()
			pound_velocity = -(jump_height) / jump_time_to_peak

# sets direction
func _pound():
	pound_direction.x *=2
	velocity += pound_direction*pound_velocity


#when the timer ends, the player will loose the momentum as requested
func _on_poundTimer_timeout():
	animation_walk = "walk"
	momentum=false
