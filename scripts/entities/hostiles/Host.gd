extends Hostile
class_name Host

var occupier: Entity = null

func _process(delta):
	if attack_target && attack_target.health <= 0:
		attack_target = null
		collision_mask = 0b0111
		
	queue_redraw()
	if !process_and_skip(delta):
		if !occupier:
			return

		if Input.is_action_just_pressed("primary_action"):
			primary_action()

		elif Input.is_action_just_pressed("secondary_action"):
			secondary_action()

		else:
			var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

			velocity = input_direction * speed * delta 

			if collider_count.count == 0:
				move_and_slide()
		occupier.position = global_position
		occupier.actual_position = global_position

func process_and_skip(_delta: float) -> bool:
	return false

func primary_action():
	pass
func secondary_action():
	pass

func _on_damaged(by: Entity):
	if by == self:
		return
	if by == occupier:
		return

	attack_target = by
