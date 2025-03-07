extends PlayerState

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.stop()
    state_machine.animation_player.play("Moving")

func physics_update(_delta: float) -> void:
    if Input.is_action_pressed("tertiary_action"):
        finished.emit(LUNGING)
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction == Vector2.ZERO:
        finished.emit(IDLE)
        return

    var angle = atan2(direction.y, direction.x)
    var rounded_angle = (PI / 4) * round(angle / (PI / 4))
    direction = Vector2(cos(rounded_angle), sin(rounded_angle))
    if cos(angle) > 0:
        state_machine.sprite.flip_h = false
    else:
        state_machine.sprite.flip_h = true
    
    player.velocity = direction * player.speed * _delta
 
    player.position = player.actual_position
    player.move_and_slide()
    player.actual_position = player.position
    player.position = player.position.round()
