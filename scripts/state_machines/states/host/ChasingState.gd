extends HostState

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

func physics_update(_delta: float):
	if entity.attack_target == null:
		finished.emit(ROAMING)
		return
	elif entity.occupier:
		finished.emit(P_IDLE)
		return

	# Check if has line of sight
	entity.raycast.target_position = entity.to_local(entity.attack_target.global_position)
	if entity.raycast.is_colliding():
		var collider = entity.raycast.get_collider()
		entity.raycast_collision_point = entity.to_local(entity.raycast.get_collision_point())
		if collider != entity.attack_target:
			finished.emit(ROAMING)

	# Check if in attack range
	if entity.to_local(entity.attack_target.global_position).length() < entity.attack_range_area_collider.shape.radius:
		finished.emit(ATTACKING)
		return

	var angle = (entity.attack_target.global_position - entity.attack_range_area_collider.global_position).angle()
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	entity.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	if cos(rounded_angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	entity.velocity = entity.attack_direction * entity.speed * _delta
	entity.move_and_slide()

func exit():
	entity.raycast.target_position = Vector2.ZERO
