extends CharacterBody2D
class_name Entity

signal health_changed(new_health: int, old_health: int)
signal health_set(health: int, max_health: int)

@export var master: Master
@export var state_machine: StateMachine
@export var speed = 500.00
@export var max_health = 100
@export var health = 100


var actual_position: Vector2
var attack_direction: Vector2

func _ready():
	health_changed.emit(health, health)

func damage(amount: int, by: Entity = null) -> void:
	health = max(0, health - amount)
	health_changed.emit(health, health + amount)
	health_set.emit(health, max_health)

	_on_damaged(by)
	_on_health_set(health, health + amount)

	if health <= 0 && state_machine:
		state_machine.change_state("Dead")
	else:
		state_machine.change_state("Damaged", {
			"by": by
		})

func _on_damaged(_by: Entity):
	pass

func heal(amount: int) -> void:
	health = min(max_health, health + amount)
	health_changed.emit(health, health - amount)
	health_set.emit(health, max_health)

	_on_heal()
	_on_health_set(health, health - amount)

func _on_heal():
	pass

func _on_health_set(_new_health: int, _max_health: int) -> void:
	pass
