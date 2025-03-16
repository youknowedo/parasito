extends ShooterState

@export var projectile: PackedScene
@export var attack_wait_time = 1.0;
@export var attack_damage = 5
@export var projectile_speed = 100.0

var attack_timer = 0.0
var timer_started = false
var started_by_occupier = false

func enter(_previous: String, _data: Dictionary = {}):
	if entity.attack_direction.x < 0:
		entity.state_machine.sprite.flip_h = true
	else:
		entity.state_machine.sprite.flip_h = false
	entity.state_machine.animation_player.stop()
	entity.state_machine.animation_player.play("Idle")
	attack_timer = attack_wait_time if !entity.occupier else 0.0
	started_by_occupier = entity.occupier

func update(_delta: float):
	if !entity.occupier && entity.attack_target == null:
		finished.emit(ROAMING)
		return

	if !started_by_occupier && entity.occupier:
		finished.emit(P_IDLE)
		return
	
	if (entity.occupier || timer_started) && attack_timer >= 0:
		attack_timer -= _delta
	if attack_timer < 0:
		if entity.attack_direction.y > 0.0001:
			if entity.attack_direction.x > 0.0001 || entity.attack_direction.x < -0.0001:
				state_machine.animation_player.play("Attacking_D_Down")
			else:
				state_machine.animation_player.play("Attacking_Down")
		elif entity.attack_direction.y < -0.0001:
			if entity.attack_direction.x > 0.0001 || entity.attack_direction.x < -0.0001:
				state_machine.animation_player.play("Attacking_D_Up")
			else:
				state_machine.animation_player.play("Attacking_Up")
		else:
			state_machine.animation_player.play("Attacking")

		var new_projectile: Projectile = projectile.instantiate()
		new_projectile.attack_damage = attack_damage
		new_projectile.velocity = entity.attack_direction * projectile_speed
		new_projectile.origin = entity
		entity.add_child(new_projectile)
		attack_timer = attack_wait_time

		return

	if entity.occupier:
		return
	
	entity.raycast_collision_point = entity.to_local(entity.attack_target.global_position)
	if entity.raycast.is_colliding():
		var collider = entity.raycast.get_collider()
		if collider != entity.attack_target:
			finished.emit(ROAMING)

	if entity.attack_direction.x > 0:
		entity.state_machine.sprite.flip_h = false
	else:
		entity.state_machine.sprite.flip_h = true

	var direction = entity.to_local(entity.attack_target.global_position)
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	entity.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))
	if abs(rounded_angle - angle) > 3 * PI / 180:
		timer_started = false
		attack_timer = attack_wait_time

		var dot = entity.attack_direction.dot(direction)
		var new_local_pos = entity.attack_direction * dot

		direction = direction - new_local_pos
		angle = atan2(direction.y, direction.x)
		rounded_angle = (PI / 4) * round(angle / (PI / 4))
		entity.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

		entity.velocity = entity.attack_direction * entity.speed * _delta
		entity.move_and_slide()
	else:
		timer_started = true


func _on_animation_finished(anim_name: StringName) -> void:
	if !anim_name.begins_with("Attacking"):
		return

	if entity.occupier:
		finished.emit(P_IDLE)
	else:
		finished.emit(ROAMING)
