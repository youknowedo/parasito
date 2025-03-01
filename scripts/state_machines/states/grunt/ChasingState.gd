extends GruntState

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.play("Moving")

func physics_update(_delta: float):
    if grunt.attack_target == null:
        finished.emit(ROAMING)
        return

    grunt.raycast.target_position = grunt.to_local(grunt.attack_target.global_position)
    if grunt.raycast.is_colliding():
        var collider = grunt.raycast.get_collider()
        grunt.raycast_collision_point = grunt.to_local(grunt.raycast.get_collision_point())
        if collider != grunt.attack_target:
            finished.emit(ROAMING)

    if grunt.in_attack_range:
        finished.emit(ATTACKING)

    var direction = (grunt.attack_target.global_position - grunt.global_position).normalized()
    # Convert direction to 8 directions
    var angle = atan2(direction.y, direction.x)
    var rounded_angle = (PI / 4) * round(angle / (PI / 4))
    direction = Vector2(cos(rounded_angle), sin(rounded_angle))
    if cos(angle) > 0:
        state_machine.sprite.flip_h = false
    else:
        state_machine.sprite.flip_h = true

    grunt.velocity = direction * grunt.speed * _delta
    grunt.move_and_slide()

func exit():
    grunt.raycast.target_position = Vector2.ZERO
