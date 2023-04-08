extends KinematicBody2D
class_name Actor


# Player number (1-2)
export var player_index: int = 1

## === X velocity === ##
export var max_speed: float = 500
export var acceleration: float = 50
export var turning_acceleration: float = 150
export var decceleration: float = 150

## === Y Velocity === ##
export var jump_height: float = 200
export var jump_time_to_peak: float = 0.25
export var jump_time_to_decent: float = 0.35
export var jump_cut: float = 0.25
export var jump_buffer: float = 0.15
export var terminal_velocity: float = 1000

## === Movement variables === ##
onready var velocity := Vector2.ZERO
onready var distance := Vector2(0, 0)
# basic projectile motion calculations
onready var jump_velocity := (2.0 * jump_height) / jump_time_to_peak 
onready var jump_gravity := (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
onready var fall_gravity := (2.0 * jump_height) / (jump_time_to_decent * jump_time_to_decent)
onready var jump_buffer_timer := jump_buffer
# animations
onready var _animated_sprite = $AnimatedSprite
var animation_walk = "walk"
var animation_idle = "idle"
var animation_jump = "jump"

var hooked = false
var hooking = false
var bridging = false
var jump_pressed = false
var can_pound=false


func get_input() -> Dictionary:
	# use inputs according to player_index
	var move_left = "p%d_left" % player_index
	var move_right = "p%d_right" % player_index
	var jump = "p%d_jump" % player_index

	return {
		"move": int(Input.is_action_pressed(move_right)) - int(Input.is_action_pressed(move_left)),
		"holding_jump": Input.is_action_pressed(jump),
		"pressed_jump": Input.is_action_just_pressed(jump),
		"released_jump": Input.is_action_just_released(jump)
	}

 
func _physics_process(delta: float) -> void:
	# the player can't move freely while grapelling
	if !(hooked):
		x_movement(delta)
		y_movement(delta)
	play_animations(delta)
	_hook_physics(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	distance += velocity


func play_animations(_delta: float) -> void:
	if velocity.x and is_on_floor():
		_animated_sprite.speed_scale = 5.0
		_animated_sprite.play(animation_walk)
	elif velocity.y < 0:
		_animated_sprite.speed_scale = 0.5
		_animated_sprite.play(animation_jump)
	else:
		if can_pound:
			return
		_animated_sprite.play(animation_walk)
		_animated_sprite.set_frame(0)
		_animated_sprite.stop()


func _hook_physics(_delta: float):
	pass
	

# TODO: jump coyote
func y_movement(delta: float) -> void:
	var input = get_input()
	var is_jumping := not is_on_floor()
	var is_falling := velocity.y > 0
	
	# if the player isn't jumping , the buffer timer is set to zero
	if not is_jumping:
		jump_buffer_timer = jump_buffer
	# start timer on jump
	if jump_pressed:
		jump_buffer_timer -= delta
		# if buffer == 0 cancel jump
		if jump_buffer_timer <= 0:
			jump_buffer_timer = jump_buffer
			jump_pressed = false

	# jump with jump button ot if jump_pressed is still true else set jump pressed to true
	if is_on_floor():
		if input["pressed_jump"] or jump_pressed:
			velocity.y = -jump_velocity
	else:
		if input["pressed_jump"]:
			jump_pressed = true

	if input["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)

	var gravity = fall_gravity if is_falling else jump_gravity
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)


func x_movement(_delta: float) -> void:
	var x_dir: int = get_input()["move"]
	
	# Choose between turning and normal accel
	var accel := acceleration if x_dir == sign(velocity.x) or velocity.x == 0 else turning_acceleration
		
	# handle accel and deccel
	if x_dir:
		velocity.x = x_dir * move_toward(abs(velocity.x), max_speed, accel)
		_animated_sprite.flip_h = x_dir < 0
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration)
