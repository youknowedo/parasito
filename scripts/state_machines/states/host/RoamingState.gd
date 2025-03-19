extends HostState

@export var roaming_radius = 32

var target = random_inside_unit_circle() * roaming_radius

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

func update(_delta: float):
	if entity.occupier:
		finished.emit(P_IDLE)
		return

	if entity.attack_target:
		entity.raycast.target_position = entity.to_local(entity.attack_target.global_position)
		entity.raycast_collision_point = entity.raycast.target_position
		entity.raycast.collision_mask = 0b1111
		if entity.raycast.is_colliding():
			var collider = entity.raycast.get_collider()
			entity.raycast_collision_point = entity.to_local(entity.raycast.get_collision_point())
			if collider == entity.attack_target:
				finished.emit(CHASING)
				return

	var direction = target - owner.global_position
	if direction.length() < 10:
		target = random_inside_unit_circle() * roaming_radius
		return
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	entity.raycast2.target_position = direction * 24
	if entity.raycast2.is_colliding():
		var collider = entity.raycast2.get_collider()
		if collider != owner:
			target = random_inside_unit_circle() * roaming_radius
			return

	if cos(angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	entity.velocity = direction.normalized() * entity.speed * _delta
	if entity.collider_count.count == 0:
		entity.move_and_slide()

func random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
