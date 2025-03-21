extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.host.connect("health_set", on_host_health_set)
	entity.collision_layer = 0b0000
	entity.visible = false

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("tertiary_action"):
		finished.emit(LUNGING)
		return

	if !entity.host:
		finished.emit(LUNGING)

func exit():
	entity.host.occupier = null
	entity.host.attack_target = entity
	entity.host.in_attack_range = true
	entity.host.disconnect("health_set", on_host_health_set)
	entity.host = null

	entity.player_health_set.emit(entity.health, entity.max_health, 0, 0)
	entity.visible = true
	entity.collision_layer = 0b0010

func on_host_health_set(health: int, max_health: int) -> void:
	entity.player_health_set.emit(entity.health, entity.max_health, health, max_health)
