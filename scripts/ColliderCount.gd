class_name ColliderCount extends Area2D

var count = 0

func _on_body_exited(body:Node2D) -> void:
    if body == owner:
        return

    count -= 1

func _on_body_entered(body:Node2D) -> void:
    if body == owner:
        return

    count += 1
