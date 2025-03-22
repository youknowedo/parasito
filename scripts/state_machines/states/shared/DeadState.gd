extends State

func enter(_previous_state_path: String, _data: Dictionary = {}):
	state_machine.animation_player.play("Dead")
	entity.collision_layer = 0b0001

	if "occupier" in entity and entity.occupier:
		entity.occupier.state_machine.change_state("Lunging")
