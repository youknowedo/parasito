extends ShooterState

@export var projectile: PackedScene
@export var attack_wait_time = 1.0;
@export var attack_damage = 5
@export var projectile_speed = 100.0

var attack_timer = 0.0
var timer_started = false

func enter(_previous: String, _data: Dictionary = {}):
	if shooter.attack_direction.x > 0:
		shooter.state_machine.sprite.flip_h = true
	else:
		print("flip_h false")
		shooter.state_machine.sprite.flip_h = false
	shooter.state_machine.animation_player.stop()
	shooter.state_machine.animation_player.play("Idle")
	attack_timer = attack_wait_time if !shooter.occupier else 0.0

func update(_delta: float):
	if !shooter.occupier && shooter.attack_target == null:
		finished.emit(ROAMING)
		return
	
	if (shooter.occupier || timer_started) && attack_timer >= 0:
		attack_timer -= _delta
	if attack_timer < 0:
		if shooter.attack_direction.y > 0.0001:
			if shooter.attack_direction.x > 0.0001 || shooter.attack_direction.x < -0.0001:
				state_machine.animation_player.play("Attacking_D_Down")
			else:
				state_machine.animation_player.play("Attacking_Down")
		elif shooter.attack_direction.y < -0.0001:
			if shooter.attack_direction.x > 0.0001 || shooter.attack_direction.x < -0.0001:
				state_machine.animation_player.play("Attacking_D_Up")
			else:
				state_machine.animation_player.play("Attacking_Up")
		else:
			state_machine.animation_player.play("Attacking")

		var new_projectile: Projectile = projectile.instantiate()
		new_projectile.attack_damage = attack_damage
		new_projectile.velocity = shooter.attack_direction * projectile_speed
		new_projectile.origin = shooter
		shooter.add_child(new_projectile)
		attack_timer = attack_wait_time

		return

	if shooter.occupier:
		return
	
	shooter.raycast_collision_point = shooter.to_local(shooter.attack_target.global_position)
	if shooter.raycast.is_colliding():
		var collider = shooter.raycast.get_collider()
		if collider != shooter.attack_target:
			finished.emit(ROAMING)

	if shooter.attack_direction.x > 0:
		shooter.state_machine.sprite.flip_h = false
	else:
		shooter.state_machine.sprite.flip_h = true

	var direction = shooter.to_local(shooter.attack_target.global_position)
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	shooter.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))
	if abs(rounded_angle - angle) > 3 * PI / 180:
		timer_started = false
		attack_timer = attack_wait_time

		var dot = shooter.attack_direction.dot(direction)
		var new_local_pos = shooter.attack_direction * dot

		direction = direction - new_local_pos
		angle = atan2(direction.y, direction.x)
		rounded_angle = (PI / 4) * round(angle / (PI / 4))
		shooter.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

		shooter.velocity = shooter.attack_direction * shooter.speed * _delta
		shooter.move_and_slide()
	else:
		timer_started = true


func _on_animation_finished(anim_name: StringName) -> void:
	if !anim_name.begins_with("Attacking"):
		return

	if shooter.occupier:
		finished.emit(P_IDLE)
	else:
		finished.emit(ROAMING)
