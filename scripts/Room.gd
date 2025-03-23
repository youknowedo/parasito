extends Node2D
class_name Room

@export var room_scene: PackedScene = null
@export var exit_point: Node2D = null
@export var player_spawn_point: Node2D = null
@export var spawn_points: Array[Node2D] = []
@export var navigation_region: NavigationRegion2D = null

var enemies: Array[PackedScene] = []
