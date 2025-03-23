class_name Damaged extends State

@export var weight = 1.0
var timer = 0.0
var by: Entity
var previous_state_path: String
var knock_back_direction: Vector2

func enter(_previous_state_path: String, _data: Dictionary = {
	by: null
}):
	if entity.health <= 0:
		finished.emit(DEAD)
		return

	if _previous_state_path != DAMAGED:
		previous_state_path = _previous_state_path
	timer = 0.2


	by = _data.by
	var direction = -entity.to_local(by.global_position).normalized() if by else Vector2.ZERO
	var angle = atan2(direction.y, direction.x)
	print(angle)
	var rounded_angle = (PI / 4) * round(angle / (PI / 4))
	knock_back_direction = Vector2(cos(rounded_angle), sin(rounded_angle)) if by else Vector2.ZERO

func update(_delta: float) -> void:
	state_machine.sprite.visible = !state_machine.sprite.visible

	timer -= _delta
	if timer <= 0:
		finished.emit(previous_state_path, {
			"by": by
		})

	entity.velocity = knock_back_direction * 3000 * _delta * (1.0 / weight)
	entity.move_and_slide()

func exit() -> void:
	state_machine.sprite.visible = true
