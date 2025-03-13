extends Control
class_name Health

@export var host_health_bar: TextureProgressBar
@export var parasite_health_bar: TextureProgressBar

@export var host_digit_1_f: Sprite2D
@export var host_digit_2_f: Sprite2D
@export var host_digit_1_b: Sprite2D
@export var host_digit_2_b: Sprite2D

@export var parasite_digit_1_f: Sprite2D
@export var parasite_digit_2_f: Sprite2D
@export	var parasite_digit_1_b: Sprite2D
@export var parasite_digit_2_b: Sprite2D

func _on_player_health_set(health:int, max_health:int, host_health:int, max_host_health:int) -> void:
	parasite_health_bar.value = health
	parasite_health_bar.max_value = max_health

	if max_host_health == 0:
		host_health_bar.value = 0
		return

	host_health_bar.value = host_health
	host_health_bar.max_value = max_host_health

	host_digit_1_b.frame_coords.x = host_health % 6
	host_digit_1_f.frame_coords.x = host_digit_1_b.frame_coords.x
	host_digit_2_b.frame_coords.x = host_health / 6
	host_digit_2_f.frame_coords.x = host_digit_2_b.frame_coords.x

	print("Host health: ", host_health, "/", max_host_health)
	
	parasite_digit_1_b.frame_coords.x = health % 6
	parasite_digit_1_f.frame_coords.x = parasite_digit_1_b.frame_coords.x
	parasite_digit_2_b.frame_coords.x = health / 6
	parasite_digit_2_f.frame_coords.x = parasite_digit_2_b.frame_coords.x
