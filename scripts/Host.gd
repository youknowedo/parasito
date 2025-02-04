extends CharacterBody2D
class_name Host

@export var dash_timer = 0.2
@export var dash_force = 1000.0

var player: Player = null

var is_dashing = false
var dash_direction = Vector2.ZERO

func primary_action():
	player.follow_host = true
	is_dashing = true
	
	var mouse_position = get_global_mouse_position()
	dash_direction = (mouse_position - global_position).normalized() * dash_force

func secondary_action():
	pass
