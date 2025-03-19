extends HostState

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

func physics_update(_delta: float):
	if host.attack_target == null:
		finished.emit(ROAMING)
		return
	elif host.occupier:
		finished.emit(P_IDLE)
		return

	# Check if has line of sight
	host.raycast.target_position = host.to_local(host.attack_target.global_position)
	if host.raycast.is_colliding():
		var collider = host.raycast.get_collider()
		host.raycast_collision_point = host.to_local(host.raycast.get_collision_point())
		if collider != host.attack_target:
			finished.emit(ROAMING)

	# Check if in attack range
	if host.in_attack_range:
		finished.emit(ATTACKING)
		return

	var angle = (host.attack_target.global_position - host.attack_range_area_collider.global_position).angle()
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	host.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	if cos(rounded_angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	host.velocity = host.attack_direction * host.speed * _delta
	if host.collider_count.count == 0:
		host.move_and_slide()

func exit():
	host.raycast.target_position = Vector2.ZERO
