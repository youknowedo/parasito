extends CharacterBody2D
class_name Player

@export var speed = 1000.0
@export var lunge_force = 500.0
@export var lunge_duration = 0.2

var is_lunging = false
var lunge_timer = 0.0
var lunge_direction = Vector2.ZERO

var host: Host = null

func _process(delta):
	if is_lunging:
		lunge_timer -= delta
		if lunge_timer <= 0:
			is_lunging = false
			
			collision_mask = 0b0111
	else:
		handle_input(delta)

	move_and_slide()

func handle_input(delta: float):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_just_pressed("primary_action"):
		if host:
			host.primary_action()
		elif !is_lunging:
			lunge()

	elif Input.is_action_just_pressed("secondary_action"):
		if host:
			host.secondary_action()

	elif Input.is_action_just_pressed("tertiary_action"):
		if host:
			lunge()
	
	else:
		velocity = host.velocity if host else lunge_direction if is_lunging else (input_direction * speed * delta * 100)

	if host:
		velocity = host.velocity

func lunge():
	is_lunging = true
	lunge_timer = lunge_duration

	collision_mask = 0b0011

	var mouse_position = get_global_mouse_position()
	lunge_direction = (mouse_position - global_position).normalized() * lunge_force

	if host:
		host.player = null
		host = null

func _on_body_entered(body: Host) -> void:
	host = body
	host.player = self
	position = body.global_position

	is_lunging = false
	lunge_timer = 0.0
