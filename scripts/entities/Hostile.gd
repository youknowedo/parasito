extends Entity
class_name Hostile

@export var raycast: RayCast2D
@export var vision_area: Area2D
@export var vision_area_collider: CollisionShape2D
@export var attack_range_area: Area2D
@export var attack_range_area_collider: CollisionShape2D
@export var attack_wait_time = 1.0

@onready var attack_timer = attack_wait_time

var in_attack_range = false
var attack_target: Player = null
var raycast_collision_point = Vector2.ZERO

func _draw():
	draw_circle(Vector2.ZERO, vision_area_collider.shape.radius, Color(0, 1, 0), false, 1)
	draw_circle(Vector2.ZERO, attack_range_area_collider.shape.radius, Color(1, 0, 0), false, 1)
	draw_line(Vector2.ZERO, raycast_collision_point, Color(0, 0, 1))

func _on_draw():
	pass

func _ready():
	vision_area = vision_area if vision_area else get_node("VisionRange")
	vision_area_collider = vision_area_collider if vision_area_collider else vision_area.get_node("VisionRange/CollisionShape2D")
	attack_range_area = attack_range_area if attack_range_area else get_node("AttackRange")
	attack_range_area_collider = attack_range_area_collider if attack_range_area_collider else attack_range_area.get_node("AttackRange/CollisionShape2D")

	vision_area.connect("body_entered", on_body_entered_vision_range)
	vision_area.connect("body_exited", on_body_exited_vision_range)
	attack_range_area.connect("body_entered", on_body_entered_attack_range)
	attack_range_area.connect("body_exited", on_body_exited_attack_range)

func _process(_delta: float) -> void:
	queue_redraw()

func on_body_entered_vision_range(body: Node2D):
	if !body.is_in_group("player"):
		return
	
	attack_target = body
	collision_mask = 0b0101

	_on_body_entered_vision_range(body)

func _on_body_entered_vision_range(_body: Node2D):
	pass

func on_body_exited_vision_range(body: Node2D):
	if body != attack_target:
		return
	
	attack_target = null
	collision_mask = 0b0011

	_on_body_exited_vision_range(body)

func _on_body_exited_vision_range(_body: Node2D):
	pass

func on_body_entered_attack_range(body: Node2D):
	if body != attack_target:
		return
	
	in_attack_range = true

	_on_body_entered_attack_range(body)

func _on_body_entered_attack_range(_body: Node2D):
	pass

func on_body_exited_attack_range(body: Node2D):
	if body != attack_target:
		return
	
	in_attack_range = false

	_on_body_exited_attack_range(body)

func _on_body_exited_attack_range(_body: Node2D):
	pass
