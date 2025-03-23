extends HostileState

@export var roaming_radius = 32

var target = Vector2.ZERO
var recalculate_path_timer: float = 0.0

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Moving")

	recalculate_path_timer = hostile.recalculate_path_wait_time
	target = NavigationServer2D.region_get_random_point(hostile.master.navigation_region.get_rid(), 1, false)

func update(_delta: float):
	if "occupier" in hostile && hostile.occupier:
		finished.emit(HostState.P_IDLE)
		return

	if hostile.target_last_known_position != Vector2.ZERO && hostile.global_position.distance_to(hostile.target_last_known_position) < hostile.navigation_agent.path_desired_distance:
		hostile.navigation_agent.target_position = hostile.target_last_known_position
		finished.emit(CHASING)
		return

	if hostile.attack_target:
		hostile.raycast.target_position = hostile.to_local(hostile.attack_target.global_position)
		hostile.raycast_collision_point = hostile.raycast.target_position
		hostile.raycast.collision_mask = 0b1111
		if hostile.raycast.is_colliding():
			var collider = hostile.raycast.get_collider()
			hostile.raycast_collision_point = hostile.to_local(hostile.raycast.get_collision_point())
			if collider == hostile.attack_target:
				finished.emit(CHASING)
				return

	if recalculate_path_timer > 0.0:
		recalculate_path_timer -= _delta
	else:
		recalculate_path_timer = hostile.recalculate_path_wait_time
		hostile.navigation_agent.target_position = target

func physics_update(_delta: float):
	if target == Vector2.ZERO || (hostile.navigation_agent.is_navigation_finished() && hostile.position.distance_to(target) < 12):
		target = NavigationServer2D.region_get_random_point(hostile.master.navigation_region.get_rid(), 1, false)
		hostile.navigation_agent.target_position = target

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

func random_inside_unit_circle() -> Vector2:
	var theta: float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
