extends GruntState

@export var roaming_radius = 100.0

var target = random_inside_unit_circle() * roaming_radius

func update(_delta: float):
    if grunt.occupier:
        finished.emit(P_IDLE)
        return

    if grunt.attack_target:
        grunt.raycast.target_position = grunt.to_local(grunt.attack_target.global_position)
        if grunt.raycast.is_colliding():
            var collider = grunt.raycast.get_collider()
            grunt.raycast_collision_point = grunt.to_local(grunt.raycast.get_collision_point())
            if collider == grunt.attack_target:
                finished.emit(CHASING)
                return

    var direction = target - owner.global_position
    if direction.length() < 10:
        target = random_inside_unit_circle() * roaming_radius
        return

    grunt.velocity = direction.normalized() * grunt.speed * _delta
    grunt.move_and_slide()

func random_inside_unit_circle() -> Vector2:
    var theta : float = randf() * 2 * PI
    return Vector2(cos(theta), sin(theta)) * sqrt(randf())
