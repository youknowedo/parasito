extends "res://scripts/Host.gd"

@export var dash_force = 500.0
@export var dash_duration = 0.2
@export var vision_collider: CollisionShape2D = null
@export var attack_range_collider: CollisionShape2D = null

var in_attack_range = false
var attack_timer = 1.0
var attack_target: Player = null

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO

func _draw():
	draw_circle(Vector2.ZERO, vision_collider.shape.radius, Color(1, 0, 0), false, 1)
	draw_circle(Vector2.ZERO, attack_range_collider.shape.radius, Color(0, 1, 0), false, 1)

func process_and_skip(delta: float) -> bool:
	queue_redraw()

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction
		return true

	if attack_target:
		if in_attack_range:
			attack_timer -= delta
			if attack_timer <= 0:
				attack_target.damage(10)
				attack_timer = 1.0

			return false
		var direction = (attack_target.global_position - global_position).normalized()
		velocity = direction * speed * delta * 100
		move_and_slide()
		return true

	return false

func primary_action():
	is_dashing = true
	
	var mouse_position = get_global_mouse_position()
	dash_direction = (mouse_position - global_position).normalized() * dash_force
	dash_timer = dash_duration

func _on_body_entered_vision_range(body: Node2D):
	if !body.is_in_group("player"):
		return
	
	attack_target = body
	collision_mask = 0b0100

func _on_body_exited_vision_range(body: Node2D):
	if body != attack_target:
		return
	
	attack_target = null
	collision_mask = 0b0010

func _on_body_entered_attack_range(body: Node2D):
	print("entered attack range")
	if body != attack_target:
		return
	
	in_attack_range = true

func _on_body_exited_attack_range(body: Node2D):
	print("exited attack range")
	if body != attack_target:
		return
	
	in_attack_range = false
