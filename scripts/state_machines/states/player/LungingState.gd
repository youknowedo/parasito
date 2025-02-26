extends PlayerState

@export var lunge_force = 500.0
@export var lunge_duration = 0.2

var lunge_timer = 0.0
var lunge_direction = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
    lunge_timer = lunge_duration

    player.collision_mask = 0b0011

    var mouse_position = player.get_global_mouse_position()
    lunge_direction = (mouse_position - player.position).normalized()

    if player.host:
        player.host.occupier = null
        player.host = null
        player.collision_layer = 0b0010

func physics_update(_delta: float) -> void:
    lunge_timer -= _delta
    
    if lunge_timer <= 0:
        finished.emit(IDLE)
        return

    player.velocity = lunge_direction * lunge_force * _delta

    player.position = player.actual_position
    player.move_and_slide()
    player.actual_position = player.position
    player.position = player.position.round()

func exit() -> void:
    player.collision_mask = 0b0111

func _on_body_entered(body: Node2D) -> void:
    print("body entered")
    if !body.is_in_group("host"):
        return

    player.host = body
    player.host.occupier = player
    player._on_health_set(player.health, body.health)

    finished.emit(POSSESSING)    
