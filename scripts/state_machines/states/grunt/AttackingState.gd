extends GruntState

@export var attack_wait_time = 1.0;
@export var attack_damage = 5

var attack_timer = 0.0

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.play("Idle")
    attack_timer = attack_wait_time if !grunt.occupier else 0.0 

func update(_delta: float):
    if attack_timer >= 0:
        attack_timer -= _delta
    if attack_timer < 0:
        state_machine.animation_player.play("Attacking")
        attack_timer = attack_wait_time if !grunt.occupier else 0.0

func _on_animation_finished(anim_name: StringName) -> void:
    if anim_name != "Attacking":
        return
    
    for body in grunt.attack_range_area.get_overlapping_bodies():
        body.damage(attack_damage, grunt)

    finished.emit(P_IDLE if grunt.occupier else CHASING)
