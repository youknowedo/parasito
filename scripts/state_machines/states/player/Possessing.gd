extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
    player.collision_layer = 0b0100

func update(_delta: float) -> void:
    if Input.is_action_just_pressed("tertiary_action"):
        finished.emit(LUNGING)
        return

    if !player.host:
        finished.emit(LUNGING)
