extends Hostile

@export var attack_damage = 10
@export var lunge_force = 6000.0
@export var lunge_duration = 0.2

var is_lunging = false
var lunge_timer = 0.0
var lunge_direction = Vector2.ZERO

var charging = false

func _process(delta: float):
	queue_redraw()
	if is_lunging:
		lunge_timer -= delta
		if lunge_timer <= 0:
			is_lunging = false
		velocity = lunge_direction * lunge_force * delta
		move_and_slide()
		return

	if attack_target:
		if in_attack_range:
			if !charging:
				lunge_direction = (attack_target.global_position - global_position).normalized()
			charging = true

		if charging:
			attack_timer -= delta
			if attack_timer <= 0:
				charging = false
				attack_timer = attack_wait_time
				is_lunging = true
				lunge_timer = lunge_duration

			return

		raycast.target_position = to_local(attack_target.global_position)
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider != attack_target:
				return

		var direction = (attack_target.global_position - global_position).normalized()
		velocity = direction * speed * delta
		move_and_slide()
		return true

	return false

func _on_body_entered_inside_area(body: Player) -> void:
	if !body.is_in_group("player"):
		return

	body.damage(attack_damage)
	queue_free()
