extends Node2D

@export var player: Player
@export var rooms: Array[PackedScene] = []
@export var enemies: Array[PackedScene] = []

func _ready() -> void:

	var initial_room: Room = rooms[randi() % rooms.size()].instantiate()
	initial_room.position = Vector2.ZERO
	player.actual_position = initial_room.player_spawn_point.position
	initial_room.enemies = enemies

	add_child(initial_room)
