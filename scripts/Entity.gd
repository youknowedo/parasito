extends CharacterBody2D
class_name Entity

signal health_changed(new_health: int, old_health: int)
signal health_set(health: int, max_health: int)

@export var speed = 500.00
@export var max_health = 100
@export var health = 100

func _ready():
	health_changed.emit(health, health)

func damage(amount: int) -> void:
	health = max(0, health - amount)
	health_changed.emit(health, health + amount)
	health_set.emit(health, max_health)

	_on_damage()
	_on_health_set(health, health + amount)

func _on_damage():
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
