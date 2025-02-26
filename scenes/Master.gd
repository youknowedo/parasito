extends Node2D

@export var player: Player
@export var rooms: Array[PackedScene] = []
@export var enemies: Array[PackedScene] = []

@export var exit_area: Area2D

var current_room_index = -1
var current_room: Room

func _ready() -> void:
	init_room()

func init_room() -> void:
	var i = randi() % rooms.size()
	while i == current_room_index:
		i = randi() % rooms.size()
	current_room_index = i

	current_room = rooms[current_room_index].instantiate()
	current_room.position = Vector2.ZERO
	player.position = current_room.player_spawn_point.position
	player.actual_position = player.position
	current_room.enemies = enemies
	exit_area.position = current_room.exit_point.position

	add_child(current_room)


func _on_area_body_entered_exit(body:Node2D) -> void:
	if !body.is_in_group("player"):
		return

	current_room.queue_free()
	init_room()
