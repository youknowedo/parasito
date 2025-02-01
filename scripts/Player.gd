extends CharacterBody2D

@export var speed = 1000.0
@export var lunge_force = 500.0
@export var lunge_duration = 0.2

var is_lunging = false
var lunge_timer = 0.0
var lunge_direction = Vector2.ZERO

func _process(delta):
	print("Player process")
	print(is_lunging, lunge_timer)
	if is_lunging:
		lunge_timer -= delta
		if lunge_timer <= 0:
			is_lunging = false
	else:
		move_input(delta)


	move_and_slide()

func move_input(delta: float):
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")

	if Input.is_action_just_pressed("primaryAction"):
		is_lunging = true
		lunge_timer = lunge_duration
		
		var mouse_position = get_global_mouse_position()
		lunge_direction = (mouse_position - global_position).normalized() * lunge_force
	
	velocity = (input_direction * speed * delta * 100) if !is_lunging else lunge_direction
