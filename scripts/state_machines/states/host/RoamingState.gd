extends HostState

@export var roaming_radius = 32

var target = random_inside_unit_circle() * roaming_radius

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

func update(_delta: float):
	if host.occupier:
		finished.emit(P_IDLE)
		return

	if host.attack_target:
		host.raycast.target_position = host.to_local(host.attack_target.global_position)
		host.raycast_collision_point = host.raycast.target_position
		host.raycast.collision_mask = 0b1111
		if host.raycast.is_colliding():
			var collider = host.raycast.get_collider()
			host.raycast_collision_point = host.to_local(host.raycast.get_collision_point())
			if collider == host.attack_target:
				finished.emit(CHASING)
				return

	var direction = target - owner.global_position
	if direction.length() < 10:
		target = random_inside_unit_circle() * roaming_radius
		return
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	host.raycast2.target_position = direction * 24
	if host.raycast2.is_colliding():
		var collider = host.raycast2.get_collider()
		if collider != owner:
			target = random_inside_unit_circle() * roaming_radius
			return

	if cos(angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	host.velocity = direction.normalized() * host.speed * _delta
	if host.collider_count.count == 0:
		host.move_and_slide()

func random_inside_unit_circle() -> Vector2:
	var theta: float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
