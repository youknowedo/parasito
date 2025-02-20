extends Host

@export var attack_damage = 5
@export var dash_force = 500.0
@export var dash_duration = 0.2

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO

func process_and_skip(delta: float) -> bool:
	queue_redraw()

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction
		return true

	if attack_target:
		if in_attack_range:
			attack_timer -= delta
			if attack_timer <= 0:
				attack_target.damage(attack_damage)
				attack_timer = 1.0

			return false
		var direction = (attack_target.global_position - global_position).normalized()
		velocity = direction * speed * delta
		move_and_slide()
		return true

	return false

func primary_action():
	is_dashing = true
	
	var mouse_position = get_global_mouse_position()
	dash_direction = (mouse_position - global_position).normalized() * dash_force
	dash_timer = dash_duration
