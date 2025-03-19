class_name Counter extends Node

@export var digits: Array[Sprite2D] = []

func set_number(number: int) -> void:
	for i in range(digits.size()):
		digits[i].frame_coords.x = (number / int(pow(6, i))) % 6

