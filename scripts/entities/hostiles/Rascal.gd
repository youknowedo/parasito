class_name Rascal extends Hostile

func _on_ready():
    state_machine.animation_player.play("Idle")
