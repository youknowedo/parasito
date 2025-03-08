extends ShooterState

@export var roaming_radius = 100.0

var target = random_inside_unit_circle() * roaming_radius

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

func update(_delta: float):
	if shooter.occupier:
		finished.emit(P_IDLE)
		return

	if shooter.attack_target:
		shooter.raycast.target_position = shooter.to_local(shooter.attack_target.global_position)
		if shooter.raycast.is_colliding():
			var collider = shooter.raycast.get_collider()
			shooter.raycast_collision_point = shooter.to_local(shooter.raycast.get_collision_point())
			if collider == shooter.attack_target:
				finished.emit(CHASING)
				return

	var direction = target - owner.global_position
	if direction.length() < 10:
		target = random_inside_unit_circle() * roaming_radius
		return
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	direction = Vector2(cos(rounded_angle), sin(rounded_angle))
	if cos(angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	shooter.velocity = direction.normalized() * shooter.speed * _delta
	shooter.move_and_slide()

func random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
