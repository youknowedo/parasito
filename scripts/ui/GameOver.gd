extends TextureRect

@export var master: Master

func _process(delta: float) -> void:
	if visible && Input.is_action_just_pressed("primary_action"):
		visible = false
		master.reset()
		

func _on_player_died() -> void:
	visible = true
