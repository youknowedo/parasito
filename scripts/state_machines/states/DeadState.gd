extends State

var original_collision_layer: int
var original_collision_mask: int

func enter(_previous_state_path: String, _data: Dictionary = {}):
	original_collision_layer = entity.collision_layer
	original_collision_mask = entity.collision_mask

	state_machine.animation_player.play("Dead")
	entity.collision_layer = 0b0000
	entity.collision_mask = 0b0000
	state_machine.sprite.z_index = -1

	if "occupier" in entity and entity.occupier:
		entity.occupier.state_machine.change_state("Lunging")

func exit():
	entity.collision_layer = original_collision_layer
	entity.collision_mask = original_collision_mask
