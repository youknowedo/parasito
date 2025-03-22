extends Hostile
class_name Host

var occupier: Player = null

func _process(delta):
	if occupier && !occupier.master.started:
		return

	if attack_target && attack_target.health <= 0:
		attack_target = null
		collision_mask = 0b0111
		
	queue_redraw()
	if !process_and_skip(delta):
		if !occupier:
			return

		if health > 0:
			if Input.is_action_just_pressed("primary_action"):
				primary_action()

			elif Input.is_action_just_pressed("secondary_action"):
				secondary_action()

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
