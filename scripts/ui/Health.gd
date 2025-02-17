extends Control
class_name Health

@export var host_health_bar: ProgressBar
@export var parasite_health_bar: ProgressBar

func _on_player_health_set(health:int, max_health:int, host_health:int, max_host_health:int) -> void:
	parasite_health_bar.value = health
	parasite_health_bar.max_value = max_health

	if max_host_health == 0:
		host_health_bar.value = 0
		return

	host_health_bar.value = host_health
	host_health_bar.max_value = max_host_health
