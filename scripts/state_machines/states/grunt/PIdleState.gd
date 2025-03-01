extends GruntState

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.play("Idle")

func update(_delta: float):
    if !grunt.occupier:
        finished.emit(ROAMING)
        return

    if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2.ZERO:
        finished.emit(P_MOVING)
        return
