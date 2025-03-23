extends HostState

var recalculate_path_timer: float = 0.0

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

	recalculate_path_timer = host.recalculate_path_wait_time

func update(_delta: float):
	if host.attack_target == null:
		finished.emit(ROAMING)
		return
	elif host.occupier:
		finished.emit(P_IDLE)
		return

	host.raycast.target_position = host.to_local(host.attack_target.global_position)
	if host.raycast.is_colliding():
		var collider = host.raycast.get_collider()
		host.raycast_collision_point = host.to_local(host.raycast.get_collision_point())
		if collider == host.attack_target:
			host.target_last_known_position = host.attack_target.global_position

			if host.in_attack_range:
				finished.emit(ATTACKING)
				return

	if recalculate_path_timer > 0.0:
		recalculate_path_timer -= _delta
	else:
		recalculate_path_timer = host.recalculate_path_wait_time
		host.navigation_agent.target_position = host.target_last_known_position

func physics_update(_delta: float):
	if host.navigation_agent.is_navigation_finished() && host.global_position.distance_to(host.target_last_known_position) < host.navigation_agent.path_desired_distance:
		finished.emit(ROAMING)		
		host.target_last_known_position = Vector2.ZERO
		return

	var next_position = host.navigation_agent.get_next_path_position()

	var direction = host.global_position.direction_to(next_position) * host.speed * _delta
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	host.velocity = Vector2(cos(rounded_angle), sin(rounded_angle)) * host.speed * _delta

	if cos(angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	if host.collider_count.count == 0:
		host.move_and_slide()

func exit():
	host.raycast.target_position = Vector2.ZERO
