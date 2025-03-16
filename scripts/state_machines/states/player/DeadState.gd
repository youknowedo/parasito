extends PlayerState

func enter(_previous_state_path:String, _data: Dictionary = {}):
	state_machine.animation_player.play("Dead")
	entity.collision_layer = 0
