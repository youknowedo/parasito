extends HostState

@export var dash_force = 500.0
@export var dash_duration = 0.2

var dash_again = false
var dash_timer = 0.0
var dash_recovery = -0.2
var dash_direction = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
	if _previous_state_path == DASHING && dash_timer > dash_recovery:
		return

	dash_timer = dash_duration

	var mouse_position = host.get_global_mouse_position()
	dash_direction = (mouse_position - host.position).normalized()
	var angle = atan2(dash_direction.y, dash_direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	dash_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	if dash_direction.x > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

func physics_update(_delta: float) -> void:
	dash_timer -= _delta
	
	if dash_timer <= dash_recovery:
		if dash_again:
			dash_again = false
			enter(DASHING)
		else:
			finished.emit(P_IDLE)
			return

	if Input.is_action_just_pressed("secondary_action"):
		dash_again = true

	if dash_timer <= 0:
		return

	host.velocity = dash_direction * dash_force * _delta

	host.move_and_slide()

func exit() -> void:
	host.collision_mask = 0b0111
