extends Control

@export var digit1: Sprite2D
@export var digit2: Sprite2D
@export var digit3: Sprite2D

var level = 0

func _on_master_new_level():
	level += 1

	digit1.frame_coords.x = level % 6
	digit2.frame_coords.x = (level / 6) % 6
	digit3.frame_coords.x = level / 36
