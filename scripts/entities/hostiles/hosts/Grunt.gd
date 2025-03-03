class_name Grunt extends Host

@export var attack_damage = 5

func primary_action():
    if !occupier:
        return

    var mouse_position = get_global_mouse_position()
    var direction = (mouse_position - global_position).normalized()
    var angle = atan2(direction.y, direction.x)
    var rounded_angle = (PI / 4) * round(angle / (PI / 4))
    direction = Vector2(cos(rounded_angle), sin(rounded_angle))
    attack_range_area.position = direction * 4

    state_machine.change_state("Attacking")
