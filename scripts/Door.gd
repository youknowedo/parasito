extends Node2D

@export var master: Master
@export var animation: AnimationPlayer

func _on_door_body_entered(body:Node2D) -> void:
	if !body.is_in_group("player") && !("occupier" in body && body.occupier):
		return

	var num_of_hostiles = master.hostiles_parent.get_child_count()
	if num_of_hostiles > 1:
		return
	if num_of_hostiles == 1 && !master.hostiles_parent.get_child(0).occupier:
		return
	
	animation.play("Open")
	