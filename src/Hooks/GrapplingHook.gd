extends Node2D
onready var colorTween = $Tween

export var hook_length : int = 1000
#here is the hook length variable
var collided = false
var pounding = false


func _on_Head_body_entered(_body):
	collided = true
#here we cehck if the hooks head has hit an object

func _on_Pound_Area_body_entered(body):
	if body.has_method("_pound"):
		if !body.is_on_ceiling():
			body.can_pound=true
			body.pound_direction = -(Vector2(0,1).rotated($Chain.rotation - PI/2))
#this is the line that sets the direction of pounding
			if body.pound_direction.y < 0:
				body.pound_direction *= -1
			print(body.pound_direction)
			pounding = true
#here we check if the red player is on the hook, we use a long area2d to detect that

func _input(event):
	if pounding:
		if event.is_action_pressed("p2_down"):
			colorTween.interpolate_property(self,"modulate",Color8(255,255,255,255),Color8(255,0,0,255),3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			colorTween.start()
#we tween the chain color to red, during 3 seconds if pound is pressed
		if event.is_action_released("p2_down"):
			colorTween.interpolate_property(self,"modulate",self.modulate,Color8(255,255,255,255),3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			colorTween.start()
#we tween the chain color back to normal if jump is released

func _on_Pound_Area_body_exited(body):
	if body.has_method("_pound"):
		body.can_pound=false
		pounding = false
#if the red player exits the robe, we remove the pounding ability from him

func _on_Tween_tween_all_completed():
	if self.modulate != Color8(255,255,255,255):
		colorTween.interpolate_property(self,"modulate",Color8(255,0,0,255),Color8(255,255,255,255),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		colorTween.start()
#we set the color to normal when tween has finished
