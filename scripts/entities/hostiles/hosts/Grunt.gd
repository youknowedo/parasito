class_name Grunt extends Host

@export var text: RichTextLabel
@export var slash_sprite: Sprite2D
@export var attack_damage = 5

var attack_again = false

func process_and_skip(_delta: float):
	text.text = str(attack_target.name) if attack_target else ""
	return false

func primary_action():
	if !occupier:
		return
	if state_machine.state.name == "Attacking":
		attack_again = true
		return

	var mouse_position = get_global_mouse_position()
	attack_direction = (mouse_position - global_position).normalized()
	var angle = atan2(attack_direction.y, attack_direction.x)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))
	attack_range_area.position = attack_direction * 4
	if cos(rounded_angle) < 0:
		state_machine.sprite.flip_h = true
	else:
		state_machine.sprite.flip_h = false

	state_machine.change_state("Attacking")
