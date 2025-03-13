class_name Shooter extends Host

@export var text: RichTextLabel
@export var attack_damage = 5

func _on_draw():
	draw_line(Vector2.ZERO, velocity.normalized() * attack_range_area_collider.shape.radius, Color(1, 0, 1))

func process_and_skip(_delta: float):
	text.text = str(attack_target.name) if attack_target else ""
	return false

func primary_action():
	if !occupier:
		return

	var mouse_position = get_global_mouse_position()
	attack_direction = (mouse_position - global_position).normalized()
	var angle = atan2(attack_direction.y, attack_direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

	state_machine.change_state("Attacking")
