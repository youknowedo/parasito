extends ShooterState

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.stop()
    state_machine.animation_player.play("Moving")

func physics_update(_delta: float):
    if shooter.attack_target == null:
        finished.emit(ROAMING)
        return
    elif shooter.occupier:
        finished.emit(P_IDLE)
        return

    # Check if has line of sight
    shooter.raycast.target_position = shooter.to_local(shooter.attack_target.global_position)
    if shooter.raycast.is_colliding():
        var collider = shooter.raycast.get_collider()
        shooter.raycast_collision_point = shooter.to_local(shooter.raycast.get_collision_point())
        if collider != shooter.attack_target:
            finished.emit(ROAMING)

    # Check if in attack range
    if shooter.to_local(shooter.attack_target.global_position).length() < shooter.attack_range_area_collider.shape.radius:
        finished.emit(ATTACKING)
        return

    var angle = (shooter.attack_target.global_position - shooter.attack_range_area_collider.global_position).angle()
    var rounded_angle = (PI / 4) * round(angle / (PI / 4))
    shooter.attack_direction = Vector2(cos(rounded_angle), sin(rounded_angle))

    shooter.velocity = shooter.attack_direction * shooter.speed * _delta
    shooter.move_and_slide()

func exit():
    shooter.raycast.target_position = Vector2.ZERO
