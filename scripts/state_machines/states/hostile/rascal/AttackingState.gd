extends HostileState

@export var attack_wait_duration = 1.0;
@export var attack_damage = 5
@export var attack_speed = 8000
@export var attack_duration = 0.5

var attack_wait_timer = 0.0
var attack_timer = 0.0
var timer_started = false

func enter(_previous: String, _data: Dictionary = {}):
	if hostile.attack_direction.x < 0:
		hostile.state_machine.sprite.flip_h = true
	else:
		hostile.state_machine.sprite.flip_h = false
	hostile.state_machine.animation_player.stop()
	hostile.state_machine.animation_player.play("Idle")

	attack_wait_timer = attack_wait_duration
	attack_timer = attack_duration

func update(_delta: float):
	if hostile.attack_target == null:
		finished.emit(ROAMING)
		return
	
	if timer_started && attack_timer >= 0:
		attack_wait_timer -= _delta
	if attack_wait_timer < 0:
		hostile.collision_layer = 0

		attack_timer -= _delta
		if attack_timer < 0:
			timer_started = false
			attack_timer = attack_duration
			attack_wait_timer = attack_wait_duration
			hostile.collision_layer = 0b0100
			return

		hostile.velocity = hostile.attack_direction * attack_speed * _delta
		hostile.move_and_slide()
		
		return
	
	hostile.raycast.target_position = hostile.to_local(hostile.attack_target.global_position)
	if hostile.raycast.is_colliding():
		var collider = hostile.raycast.get_collider()
		if collider != hostile.attack_target:
			finished.emit(ROAMING)

	if hostile.attack_direction.x > 0:
		hostile.state_machine.sprite.flip_h = false
	else:
		hostile.state_machine.sprite.flip_h = true

	var direction = hostile.to_local(hostile.attack_target.global_position)
	var angle = atan2(direction.y, direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	hostile.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))
	if abs(rounded_angle - angle) > 3 * PI / 180:
		timer_started = false
		attack_timer = attack_wait_duration

		var dot = hostile.attack_direction.dot(direction)
		var new_local_pos = hostile.attack_direction * dot

		direction = direction - new_local_pos
		angle = atan2(direction.y, direction.x)
		rounded_angle = (PI / 4) * round(angle / (PI / 4))
		hostile.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

		hostile.velocity = hostile.attack_direction * hostile.speed * _delta
		if hostile.collider_count.count == 0:
			hostile.move_and_slide()
	else:
		timer_started = true


func _on_animation_finished(anim_name: StringName) -> void:
	if !anim_name.begins_with("Attacking"):
		return

	finished.emit(ROAMING)


func _on_inside_area_body_entered(body: Node2D) -> void:
	if !body.is_in_group("entity"):
		return

	body.damage(attack_damage)

	finished.emit(ROAMING)

	hostile.queue_free()
