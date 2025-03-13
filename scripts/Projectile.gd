class_name Projectile extends Area2D 

var velocity: Vector2
var attack_damage: int
var origin: Entity

var actual_position: Vector2

func _physics_process(delta: float) -> void:
	position = actual_position
	position += velocity * delta
	actual_position = position
	position = position.round()

func _on_body_entered(body:Node2D) -> void:
	if body == origin || ("host" in body && body.host == origin):
		return

	if body.is_in_group("entity"):
		body.damage(10, origin)

	queue_free()
