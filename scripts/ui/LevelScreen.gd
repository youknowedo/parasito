class_name LevelScreen extends TextureRect

@export var master: Master
@export var timer = 5.0
@export var region_counter: Counter
@export var room_counter: Counter

@onready var _timer = timer
var timer_on = false

func _process(delta: float) -> void:
	if visible && timer != _timer && Input.is_action_just_pressed("primary_action"):
		visible = false
		_timer = 0.0

	if timer_on:
		_timer -= delta

	if timer_on && _timer <= 0:
		_timer = timer
		visible = false
		timer_on = false

		master.init_room()

func new_level(region_index: int, room_index: int) -> void:
	visible = true
	region_counter.set_number(region_index)
	room_counter.set_number(room_index)

	_timer = timer
	timer_on = true
