extends ShooterState

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.stop()
    state_machine.animation_player.play("Moving")

func physics_update(_delta: float) -> void:
    if !shooter.occupier:
        finished.emit(ROAMING)
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction == Vector2.ZERO:
        finished.emit(P_IDLE)
        return
    var angle = atan2(direction.y, direction.x)
    var rounded_angle = (PI / 4) * round(angle / (PI / 4))
    direction = Vector2(cos(rounded_angle), sin(rounded_angle))
    if cos(angle) > 0:
        state_machine.sprite.flip_h = false
    else:
        state_machine.sprite.flip_h = true
    
    shooter.velocity = direction * shooter.speed * _delta
 
    shooter.move_and_slide()
