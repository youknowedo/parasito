extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
    player.host.connect("health_set", on_host_health_set)
    player.collision_layer = 0b0000
    player.visible = false
    player.host.collision_layer = 0b0110

func update(_delta: float) -> void:
    if Input.is_action_just_pressed("tertiary_action"):
        finished.emit(LUNGING)
        return

    if !player.host:
        finished.emit(LUNGING)

func exit():
    player.host.disconnect("health_set", on_host_health_set)
    player.player_health_set.emit(player.health, player.max_health, 0, 0)
    player.visible = true
    player.host.collision_layer = 0b0010

func on_host_health_set(health: int, max_health: int) -> void:
    player.player_health_set.emit(player.health, player.max_health, health, max_health)
