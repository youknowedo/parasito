extends HostileState

var recalculate_path_timer: float = 0.0

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

	recalculate_path_timer = hostile.recalculate_path_wait_time

func update(_delta: float):
	if hostile.attack_target == null:
		finished.emit(ROAMING)
		return
	elif "occupier" in hostile && hostile.occupier:
		finished.emit(HostState.P_IDLE)
		return

	hostile.raycast.target_position = hostile.to_local(hostile.attack_target.global_position)
	if hostile.raycast.is_colliding():
		var collider = hostile.raycast.get_collider()
		hostile.raycast_collision_point = hostile.to_local(hostile.raycast.get_collision_point())
		if collider == hostile.attack_target:
			hostile.target_last_known_position = hostile.attack_target.global_position

			if hostile.in_attack_range:
				var direction = hostile.global_position.direction_to(hostile.attack_target.global_position)
				var angle = atan2(direction.y, direction.x)
				var rounded_angle = (PI / 4) * round(angle / (PI / 4))
				hostile.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))
				
				finished.emit(ATTACKING)
				return

	if recalculate_path_timer > 0.0:
		recalculate_path_timer -= _delta
	else:
		recalculate_path_timer = hostile.recalculate_path_wait_time
		hostile.navigation_agent.target_position = hostile.target_last_known_position

func physics_update(_delta: float):
	if hostile.navigation_agent.is_navigation_finished() && hostile.global_position.distance_to(hostile.target_last_known_position) < hostile.navigation_agent.path_desired_distance:
		finished.emit(ROAMING)
		hostile.target_last_known_position = Vector2.ZERO
		return

	var next_position = hostile.navigation_agent.get_next_path_position()

	var direction = hostile.global_position.direction_to(next_position) * hostile.speed * _delta
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	hostile.velocity = Vector2(cos(rounded_angle), sin(rounded_angle)) * hostile.speed * _delta

	if cos(angle) > 0:
		state_machine.sprite.flip_h = false
	else:
		state_machine.sprite.flip_h = true

	if hostile.collider_count.count == 0:
		hostile.move_and_slide()

func exit():
	hostile.raycast.target_position = Vector2.ZERO
