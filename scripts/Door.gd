class_name Door extends Node2D

@export var master: Master
@export var animation: AnimationPlayer

func _on_door_body_entered(body:Node2D) -> void:
	if !body.is_in_group("player") && !("occupier" in body && body.occupier):
		return

	var no_hostiles_left = true
	for child in master.hostiles_parent.get_children():
		if "occupier" in child && child.occupier:
			continue
		if child.health <= 0:
			continue	
		
		no_hostiles_left = false

	if !no_hostiles_left:
		return
	
	animation.play("Open")
	

func _on_exit_area_body_entered(body:Node2D) -> void:
	animation.play("Close")
