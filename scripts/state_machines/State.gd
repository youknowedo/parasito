class_name State extends Node

var state_machine: StateMachine = null

var entity: Entity

signal finished(_next_state_path: String, _data: Dictionary)

func _ready():
	await owner.ready
	entity = owner as Entity
	assert(entity != null, "The state type must be used only in the entity scene. It needs the owner to be a Entity node.")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass
