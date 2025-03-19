extends GruntState

@export var attack_force = 1000
@export var attack_wait_time = 0.4;
@export var attack_damage = 5

var flip_slash = false
var attack_timer = 0.0
var started_by_occupier = false

func enter(_previous: String, _data: Dictionary = {}):
	state_machine.animation_player.stop()
	state_machine.animation_player.play("Idle")
	attack_timer = attack_wait_time if !entity.occupier else -1.0
	started_by_occupier = entity.occupier
	flip_slash = !flip_slash

func update(_delta: float):
	if !started_by_occupier && entity.occupier:
		finished.emit(P_IDLE)
		return

	if attack_timer > 0:
		attack_timer -= _delta
		entity.velocity = Vector2.ZERO
	if attack_timer < 0:
		if entity.attack_direction.x >= 0:
			state_machine.sprite.flip_h = false
			grunt.slash_sprite.flip_h = false
		else:
			state_machine.sprite.flip_h = true
			grunt.slash_sprite.flip_h = true

		if entity.attack_direction.y > 0.0001:
			if entity.attack_direction.x > 0.0001 || entity.attack_direction.x < -0.0001:
				state_machine.animation_player.play(("AttackDD_Flip_H" if grunt.slash_sprite.flip_h else "AttackDD_Flip") if flip_slash else "AttackDD")
			else:
				state_machine.animation_player.play("AttackD_Flip" if flip_slash else "AttackD")
		elif entity.attack_direction.y < -0.0001:
			if entity.attack_direction.x > 0.0001 || entity.attack_direction.x < -0.0001:
				state_machine.animation_player.play(("AttackDU_Flip_H" if grunt.slash_sprite.flip_h else "AttackDU_Flip") if flip_slash else "AttackDU")
			else:
				state_machine.animation_player.play("AttackU_Flip" if flip_slash else "AttackU")
		else:
			state_machine.animation_player.play("Attack_Flip" if flip_slash else "Attack")

		attack_timer = 0
		
	if attack_timer == 0:
		entity.velocity = entity.attack_direction * attack_force * _delta
	
		if grunt.collider_count.count == 0:
			entity.move_and_slide()
				
func _on_animation_finished(anim_name: StringName) -> void:
	if !anim_name.begins_with("Attack"):
		return

	state_machine.animation_player.play("Idle")
	
	for body in entity.attack_range_area.get_overlapping_bodies():
		if body == entity:
			continue

		body.damage(attack_damage, entity)

	finished.emit(P_IDLE if entity.occupier else CHASING)
