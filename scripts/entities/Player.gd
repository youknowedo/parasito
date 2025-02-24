extends Entity
class_name Player

signal player_health_set(health: int, max_health: int, host_health: int, max_host_health: int)
signal died()

@export var passive_damage_timer_duration = 1.0
@export var lunge_force = 500.0
@export var lunge_duration = 0.2

@onready var passive_damage_timer = passive_damage_timer_duration

var is_lunging = false
var lunge_timer = 0.0
var lunge_direction = Vector2.ZERO

var host: Host = null

func _ready():
	player_health_set.emit(health, max_health, 0, 0)
	actual_position = position

func _process(delta):
	if health <= 0:
		return

	if Input.is_action_just_pressed("tertiary_action"):
		lunge()
	
	if host:
		return

	passive_damage_timer -= delta
	if passive_damage_timer <= 0:
		passive_damage_timer = passive_damage_timer_duration
		damage(1)

	if is_lunging:
		lunge_timer -= delta
		if lunge_timer <= 0:
			is_lunging = false
			
			collision_mask = 0b0111

		velocity = lunge_direction * lunge_force * delta

	else:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

		velocity = input_direction * speed * delta

	position = actual_position
	move_and_slide()
	actual_position = position
	position = position.round()

func lunge():
	is_lunging = true
	lunge_timer = lunge_duration

	collision_mask = 0b0011

	var mouse_position = get_global_mouse_position()
	lunge_direction = (mouse_position - global_position).normalized()

	if host:
		host.occupier = null
		host = null
		collision_layer = 0b0010

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("host"):
		return

	position = body.global_position
	actual_position = position
	host = body
	_on_health_set(health, host.health)
	collision_layer = 0b0100
	host.occupier = self

	is_lunging = false
	lunge_timer = 0.0

func _on_health_set(_new_health: int, _max_health: int) -> void:
	player_health_set.emit(health, max_health, host.health if host else 0, host.max_health if host else 0)

func _on_damage():
	if health <= 0:
		died.emit()
