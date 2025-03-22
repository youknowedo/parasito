extends PlayerState

@export var lunge_force = 500.0
@export var lunge_duration = 0.2

var lunge_again = false
var lunge_recovery = -0.2
var lunge_timer = 0.0
var lunge_direction = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
	if _previous_state_path == LUNGING && lunge_timer > lunge_recovery:
		return

	lunge_timer = lunge_duration

	entity.collision_mask = 0b0011

	var mouse_position = entity.get_global_mouse_position()
	lunge_direction = (mouse_position - entity.position).normalized()
	var angle = atan2(lunge_direction.y, lunge_direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	lunge_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	if lunge_direction.x > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	if entity.host:
		entity.host.occupier = null
		entity.host = null
		entity.collision_layer = 0b0010

func physics_update(_delta: float) -> void:
	lunge_timer -= _delta
	
	if lunge_timer <= lunge_recovery:
		if lunge_again:
			lunge_again = false
			enter(LUNGING)
		else:
			finished.emit(IDLE)
			return

	if Input.is_action_just_pressed("tertiary_action"):
		lunge_again = true
		
	if lunge_timer <= 0:
		return

	entity.velocity = lunge_direction * lunge_force * _delta

	entity.position = entity.actual_position
	entity.move_and_slide()
	entity.actual_position = entity.position
	entity.position = entity.position.round()

func exit() -> void:
	entity.collision_mask = 0b0111

func _on_body_entered(body: Node2D) -> void:
	if state_machine.state.name != LUNGING:
		return
	if entity.host:
		return
	
	if !body.is_in_group("host"):
		return

	entity.host = body
	entity.host.occupier = entity
	entity._on_health_set(entity.health, body.health)

	finished.emit(POSSESSING)	
