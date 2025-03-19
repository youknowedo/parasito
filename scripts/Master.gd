class_name Master extends Node2D

@export var title_rect: TextureRect
@export var level_counter: Counter
@export var player: Player
@export var regions: Array[Region] = []
@export var hostiles_parent: Node
@export var enter_door: Door

@export var level_screen: LevelScreen

@export var exit_area: Area2D

var started = false
var current_region_index = 0
var current_room_index = -1
var current_room: Room
var current_level = 0

func _ready() -> void:
	title_rect.visible = true

func _process(_delta: float) -> void:
	if !started && title_rect.visible && Input.is_action_just_pressed("primary_action"):
		title_rect.visible = false
		level_screen.new_level(1, 1)

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
	level_counter.set_number(0)
	current_level = 0

	init_room()

func init_room() -> void:
	current_level += 1
	level_counter.set_number(current_level)
	started = true
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

	current_room = regions[current_region_index].rooms[current_room_index].instantiate()
	current_room.position = Vector2.ZERO

	enter_door.position = current_room.player_spawn_point.position
	enter_door.position.x -= 32

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

func _on_area_body_entered_exit(body: Node2D) -> void:
	if started == false:
		return

	var no_hostiles_left = true
	for child in hostiles_parent.get_children():
		if "occupier" in child && child.occupier:
			continue
		if child.health <= 0:
			child.queue_free()
			continue	
		
		no_hostiles_left = false

	if !no_hostiles_left:
		return

	current_room.queue_free()
	level_screen.new_level(current_region_index + 1, current_room_index + 1)
	started = false
