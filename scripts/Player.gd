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
	if Input.is_action_just_pressed("tertiary_action"):
		lunge()
	
	if host:
		return

	if is_lunging:
		lunge_timer -= delta
		if lunge_timer <= 0:
			is_lunging = false
			
			collision_mask = 0b0111

		velocity = lunge_direction

	else:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

		velocity = input_direction * speed * delta * 100

	move_and_slide()

func lunge():
	is_lunging = true
	lunge_timer = lunge_duration

	collision_mask = 0b0011

	var mouse_position = get_global_mouse_position()
	lunge_direction = (mouse_position - global_position).normalized() * lunge_force

	if host:
		host.occupier = null
		host = null
		collision_layer = 0b0010

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("host"):
		return

	host = body
	collision_layer = 0b0100
	host.occupier = self
	position = body.global_position

	is_lunging = false
	lunge_timer = 0.0
