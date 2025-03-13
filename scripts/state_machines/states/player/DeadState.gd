extends PlayerState

func enter(_previous_state_path:String, _data: Dictionary = {}):
    state_machine.animation_player.play("Dead")
    player.collision_layer = 0
