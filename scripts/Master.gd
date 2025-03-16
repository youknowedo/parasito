class_name Master extends Node2D 

signal new_level()

@export var title_rect: TextureRect
@export var player: Player
@export var regions: Array[Region] = []
@export var hostiles_parent: Node

@export var exit_area: Area2D

var started = false
var current_region_index = 0
var current_room_index = -1
var current_room: Room

func _ready() -> void:
	title_rect.visible = true

func _process(_delta: float) -> void:
	if !started && Input.is_action_just_pressed("primary_action"):
		title_rect.visible = false
		started = true
		init_room()

func reset() -> void:
	for child in hostiles_parent.get_children():
		child.queue_free()
	if current_room:
		current_room.queue_free()
	
	for region in regions:
		region.current_level = -1

	current_region_index = 0
	current_room_index = -1
	player.reset()

	init_room()

func init_room() -> void:
	print(current_region_index, current_room_index)
	regions[current_region_index].current_level += 1
	if regions[current_region_index].num_of_levels != -1 && regions[current_region_index].current_level >= regions[current_region_index].num_of_levels:
		current_region_index += 1
		if current_region_index >= regions.size():
			current_region_index = 0
		regions[current_region_index].current_level = 0

	var i = randi() % regions[current_region_index].rooms.size()
	while regions[current_region_index].rooms.size() != 1 && i == current_room_index:
		i = randi() % regions[current_region_index].rooms.size()
	current_room_index = i

	current_room =  regions[current_region_index].rooms[current_room_index].instantiate()
	current_room.position = Vector2.ZERO
	player.position = current_room.player_spawn_point.position
	player.actual_position = player.position
	if player.host:
		player.host.position = player.position
		player.host.actual_position = player.position
	current_room.enemies = regions[current_region_index].enemies
	exit_area.position = current_room.exit_point.position

	add_child(current_room)

	for spawn_point in current_room.spawn_points:
		var enemy = current_room.enemies[randi() % current_room.enemies.size()].instantiate()
		enemy.position = spawn_point.position
		hostiles_parent.add_child(enemy)

	new_level.emit()

func _on_area_body_entered_exit(body:Node2D) -> void:
	if !body.is_in_group("player") && !("occupier" in body && body.occupier):
		return
	
	for child in hostiles_parent.get_children():
		# Check if has occupier
		if "occupier" not in child || !child.occupier:
			child.queue_free()

	current_room.queue_free()
	init_room()
