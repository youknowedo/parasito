extends GruntState

func physics_update(_delta: float) -> void:
    if !grunt.occupier:
        finished.emit(ROAMING)
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction == Vector2.ZERO:
        finished.emit(P_IDLE)
        return
    
    grunt.velocity = direction * grunt.speed * _delta
 
    grunt.move_and_slide()
