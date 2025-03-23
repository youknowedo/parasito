extends ShooterState

@export var projectile: PackedScene
@export var attack_wait_time = 1.0;
@export var attack_damage = 5
@export var projectile_speed = 100.0

var attack_timer = 0.0
var timer_started = false
var started_by_occupier = false

func enter(_previous: String, _data: Dictionary = {}):
	if host.attack_direction.x < 0:
		host.state_machine.sprite.flip_h = true
	else:
		host.state_machine.sprite.flip_h = false
	host.state_machine.animation_player.stop()
	host.state_machine.animation_player.play("Idle")
	attack_timer = attack_wait_time if !host.occupier else 0.0
	started_by_occupier = host.occupier

func update(_delta: float):
	if !host.occupier && host.attack_target == null:
		finished.emit(ROAMING)
		return

	if !started_by_occupier && host.occupier:
		finished.emit(P_IDLE)
		return
	
	if (host.occupier || timer_started) && attack_timer >= 0:
		attack_timer -= _delta
	if attack_timer < 0:
		if host.attack_direction.y > 0.0001:
			if host.attack_direction.x > 0.0001 || host.attack_direction.x < -0.0001:
				state_machine.animation_player.play("Attacking_D_Down")
			else:
				state_machine.animation_player.play("Attacking_Down")
		elif host.attack_direction.y < -0.0001:
			if host.attack_direction.x > 0.0001 || host.attack_direction.x < -0.0001:
				state_machine.animation_player.play("Attacking_D_Up")
			else:
				state_machine.animation_player.play("Attacking_Up")
		else:
			state_machine.animation_player.play("Attacking")

		var new_projectile: Projectile = projectile.instantiate()
		new_projectile.attack_damage = attack_damage
		new_projectile.velocity = host.attack_direction * projectile_speed
		new_projectile.origin = host
		new_projectile.global_position = host.global_position
		host.add_child(new_projectile)
		attack_timer = attack_wait_time

		return

	if host.occupier:
		return
	
	host.raycast.target_position = host.to_local(host.attack_target.global_position)
	if host.raycast.is_colliding():
		var collider = host.raycast.get_collider()
		if collider != host.attack_target:
			finished.emit(ROAMING)

	if host.attack_direction.x > 0:
		host.state_machine.sprite.flip_h = false
	else:
		host.state_machine.sprite.flip_h = true

	var direction = host.to_local(host.attack_target.global_position)
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	host.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))
	if abs(rounded_angle - angle) > 3 * PI / 180:
		timer_started = false
		attack_timer = attack_wait_time

		var dot = host.attack_direction.dot(direction)
		var new_local_pos = host.attack_direction * dot

		direction = direction - new_local_pos
		angle = atan2(direction.y, direction.x)
		rounded_angle = (PI / 4) * round(angle / (PI / 4))
		host.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

		host.velocity = host.attack_direction * host.speed * _delta
		if host.collider_count.count == 0:
			host.move_and_slide()
	else:
		timer_started = true


func _on_animation_finished(anim_name: StringName) -> void:
	if !anim_name.begins_with("Attacking"):
		return

	if host.occupier:
		finished.emit(P_IDLE)
	else:
		finished.emit(ROAMING)
