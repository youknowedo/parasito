extends GruntState

@export var attack_wait_time = 1.0;
@export var attack_damage = 5

var attack_timer = 0.0
var started_by_occupier = false

func enter(_previous: String, _data: Dictionary = {}):
    state_machine.animation_player.stop()
    state_machine.animation_player.play("Idle")
    attack_timer = attack_wait_time if !entity.occupier else 0.0 
    started_by_occupier = entity.occupier

func update(_delta: float):
    if !started_by_occupier && entity.occupier:
        finished.emit(P_IDLE)
        return

    if attack_timer >= 0:
        attack_timer -= _delta
    if attack_timer < 0:
        if entity.attack_direction.y > 0.0001:
            if entity.attack_direction.x > 0.0001 || entity.attack_direction.x < -0.0001:
                state_machine.animation_player.play("Attacking_D_Down")
            else:
                state_machine.animation_player.play("Attacking_Down")
        elif entity.attack_direction.y < -0.0001:
            if entity.attack_direction.x > 0.0001 || entity.attack_direction.x < -0.0001:
                state_machine.animation_player.play("Attacking_D_Up")
            else:
                state_machine.animation_player.play("Attacking_Up")
        else:
            state_machine.animation_player.play("Attacking")
                
func _on_animation_finished(anim_name: StringName) -> void:
    if !anim_name.begins_with("Attacking"):
        return
    
    for body in entity.attack_range_area.get_overlapping_bodies():
        if body == entity:
            continue

        body.damage(attack_damage, entity)

    finished.emit(P_IDLE if entity.occupier else CHASING)
