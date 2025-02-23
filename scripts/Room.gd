extends Node2D
class_name Room

@export var room_scene: PackedScene = null
@export var exit_point: Node2D = null
@export var player_spawn_point: Node2D = null
@export var spawn_points: Array[Node2D] = []

var enemies: Array[PackedScene] = []

func _ready():
	for spawn_point in spawn_points:
		var enemy = enemies[randi() % enemies.size()].instantiate()
		enemy.position = spawn_point.position
		add_child(enemy)
