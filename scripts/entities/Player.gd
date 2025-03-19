extends Entity
class_name Player

signal player_health_set(health: int, max_health: int, host_health: int, max_host_health: int)
signal died()

@export var master: Master
@export var passive_damage_timer_duration = 1.0
@onready var passive_damage_timer = passive_damage_timer_duration

var host: Host = null

func _ready():
	player_health_set.emit(max_health, max_health, 0, 0)
	actual_position = position

func _process(_delta: float):
	if state_machine.state.name == "Dead":
		return

	if host:
		return

	if master.started && passive_damage_timer > 0:
		passive_damage_timer -= _delta
		if passive_damage_timer <= 0:
			damage(1, null)
			passive_damage_timer = passive_damage_timer_duration

func _on_health_set(_new_health: int, _max_health: int) -> void:
	player_health_set.emit(health, max_health, host.health if host else 0, host.max_health if host else 0)

func _on_damaged(_by: Entity):
	if health <= 0:
		state_machine.change_state("Dead")
		died.emit()

func reset():
	health = max_health
	host = null
	player_health_set.emit(health, max_health, 0, 0)
	state_machine.change_state("Idle")
