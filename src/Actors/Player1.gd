extends Actor

# grapple code
onready var grappleHook = $"Grappling Hook"
onready var chain =$"Grappling Hook/Chain"
onready var head =$"Grappling Hook/Head"
onready var head_sprite = $"Grappling Hook/Head/Sprite"
onready var hook_collision =$"Grappling Hook/Chain/Collision/CollisionShape2D"
onready var pound_area =$"Grappling Hook/Chain/Pound Area/CollisionShape2D"

var hook_direction = Vector2.ZERO
var head_position = Vector2.ZERO
var target = Vector2.ZERO

var pull_force=50
var hookingVelocity=Vector2.ZERO
var in_air = false

func _draw() -> void:
	pass
#	this is if you want a line towards the mouse position
#	draw_line(Vector2.ZERO, (to_local(get_global_mouse_position())) , Color.white)

#	this is if you want a 256 lenght line
#	draw_line(Vector2.ZERO,  256* (to_local(get_global_mouse_position())).normalized() , Color.white)

func _input(event):
	if event.is_action_pressed("LMB"):
		_shoot_grapple(to_local(get_global_mouse_position()))
	elif event.is_action_released("LMB"):
		_release_grapple()
		_release_bridge()
	elif event.is_action_pressed("RMB"):
		_shoot_bridge(to_local(get_global_mouse_position()))
	elif event.is_action_released("RMB"):
		_release_bridge()
#as usual we check if the button is pressed, we shoot the grapple, if not we release 
#or we cancel the grapple

func _shoot_bridge(dir):
	grappleHook.collided = false
	hook_direction = dir.normalized()
	bridging = true
	head_position = grappleHook.global_position
#we use the dir variable to calculate the shooting direction

func _release_bridge():
	hook_collision.shape.extents.y = 0
	hook_collision.position.y = 0
	pound_area.shape.extents.y = 0
	pound_area.position.y = 0
	bridging = false
	hooked = false
#we set all the states to default

func _shoot_grapple(dir):
	target=dir
	grappleHook.collided = false
	hook_direction = dir.normalized()
	hooking = true
	head_position = grappleHook.global_position
#we use the dir variable to calculate the shooting direction

func _release_grapple():
	hooking = false
	hooked = false
	in_air = false
	head_sprite.show()
#we set all the states to default

func _process(_delta):
	grappleHook.visible = hooked or hooking or bridging
#if we are doing any of these actions, the hook will be visible, otherwise
#we will hide it
	if !grappleHook.visible:
		return
#if the hook isn't visible, which means we doing nothing, so we will return and not continue
	var local_head = to_local(head_position)
	var unit = Vector2(0,1)
	var length = local_head.length()
	if length > grappleHook.hook_length:
		_release_grapple()
		_release_bridge()
		return
#if the length of the hoook is bigger than the one that we set 1000, release and return
	chain.rotation = unit.angle_to(local_head.normalized())
	head.rotation = unit.angle_to(local_head.normalized()) - PI
#here we rotate the chain and the point of the hook
	chain.position = grappleHook.position
#then we set the chain position to the center of the player
	chain.region_rect.size.y = length
#we increase the length of the chain
	hook_collision.shape.extents.y = length/2
#we increase the lenth of the collision shape that the red player steps on
	hook_collision.position.y = length/2
#we fix the position of the collision shape
	pound_area.shape.extents.y = (length/2)-16
#we increase the lenth of the pounding area2d so it can detect the red player on the hook 
	pound_area.position.y = (length/2)
#we fix the position of the pounding area2d

func _hook_physics(delta):
	_grapple(delta)
	_pounder()

func _pounder():
	if bridging:
		if !grappleHook.collided:
			head.global_position = head_position
			hooked = false
			head_position += hook_direction * 20
#this moves the hook untill it's head hits something
		elif !hooked:
			hooked = true
		elif hooked:
			head.global_position = head_position
			velocity.x=0
#if his head hits something, we stop the player and maintain the hook's head position

func _grapple(delta):
	if hooking:
		if !grappleHook.collided:
			head.global_position = head_position
			hooking = true
			hooked = false
			head_position += hook_direction * 20
#this moves the hook untill it's head hits something
			var is_falling = velocity.y>0
			var gravity = fall_gravity if is_falling else jump_gravity
			velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
#we use this to keep gravity while shooting the hook
		elif !hooked:
			if head_sprite.visible:
				head_sprite.hide()
			hooked = true
		elif hooked:
			head.global_position = head_position
#if his head hits something, we maintain the hook's head position
			hookingVelocity = to_local(head_position).normalized()*pull_force
			if _on_top():
				hookingVelocity.y += pull_force*3
#if the player is on top of the hooked object, we increase the y velocity
			elif hookingVelocity.y > 0 :
				hookingVelocity.y *=0.5
#if the player is under the obecjt but he is going down, we decrease the y velocity
			else:
				hookingVelocity.y *= 1.6
#if the player is under the obecjt and he is going up, we increase the y velocity
			if sign(hookingVelocity.x) != sign(velocity.x):
#if the hook speed is the opposite of the movement speed we decrease the x velocity
				hookingVelocity.x*= 0.7
			velocity.x = clamp(velocity.x,-800,800)
			velocity.y = clamp(velocity.y,-800,800)
#we limit the velocity here so the hook don't go crazy
		else:
			hookingVelocity=Vector2.ZERO
#if the player is ! hooking, we set the hooking velocity back to Vector2(0,0)
		velocity += hookingVelocity

func _on_top():
	return (global_position.y-head_position.y)<0
#this returns true of the player is on top of the hooks head

func _physics_process(_delta: float) -> void:
	pass
	#update()
