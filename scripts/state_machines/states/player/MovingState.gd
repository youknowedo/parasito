extends PlayerState

func physics_update(_delta: float) -> void:
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if Input.is_action_pressed("tertiary_action"):
        finished.emit(LUNGING)
        return
    if direction == Vector2.ZERO:
        finished.emit(IDLE)
        return
    
    player.velocity = direction * player.speed * _delta
 
    player.position = player.actual_position
    player.move_and_slide()
    player.actual_position = player.position
    player.position = player.position.round()
