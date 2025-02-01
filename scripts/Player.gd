extends CharacterBody2D

@export var speed = 100

func get_input():
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
