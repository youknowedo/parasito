extends PlayerState

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.stop()
    state_machine.animation_player.play("Idle")

func update(_delta: float):
    if Input.is_action_just_pressed("tertiary_action"):
        finished.emit(LUNGING)
        return
    if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2.ZERO:
        finished.emit(MOVING)
        return
