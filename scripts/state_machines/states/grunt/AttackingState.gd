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
	attack_timer = attack_wait_time if !host.occupier else -1.0
	started_by_occupier = host.occupier
	flip_slash = !flip_slash

	host.attack_range_area_collider.position = host.attack_direction * 5

func update(_delta: float):
	if !started_by_occupier && host.occupier:
		finished.emit(P_IDLE)
		return

	if attack_timer > 0:
		attack_timer -= _delta
		host.velocity = Vector2.ZERO
	if attack_timer < 0:
		if host.attack_direction.x >= 0:
			state_machine.sprite.flip_h = false
			grunt.slash_sprite.flip_h = false
		else:
			state_machine.sprite.flip_h = true
			grunt.slash_sprite.flip_h = true

		if host.attack_direction.y > 0.0001:
			if host.attack_direction.x > 0.0001 || host.attack_direction.x < -0.0001:
				state_machine.animation_player.play(("AttackDD_Flip_H" if grunt.slash_sprite.flip_h else "AttackDD_Flip") if flip_slash else "AttackDD")
			else:
				state_machine.animation_player.play("AttackD_Flip" if flip_slash else "AttackD")
		elif host.attack_direction.y < -0.0001:
			if host.attack_direction.x > 0.0001 || host.attack_direction.x < -0.0001:
				state_machine.animation_player.play(("AttackDU_Flip_H" if grunt.slash_sprite.flip_h else "AttackDU_Flip") if flip_slash else "AttackDU")
			else:
				state_machine.animation_player.play("AttackU_Flip" if flip_slash else "AttackU")
		else:
			state_machine.animation_player.play("Attack_Flip" if flip_slash else "Attack")

		attack_timer = 0
		
	if attack_timer == 0:
		host.velocity = host.attack_direction * attack_force * _delta
	
		if grunt.collider_count.count == 0:
			host.move_and_slide()
				
func _on_animation_finished(anim_name: StringName) -> void:
	if !anim_name.begins_with("Attack"):
		return

	state_machine.animation_player.play("Idle")
	
	for body in host.attack_range_area.get_overlapping_bodies():
		if body == host:
			continue

		body.damage(attack_damage, host)

	finished.emit(P_IDLE if host.occupier else CHASING)
