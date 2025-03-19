class_name PlayerState extends State

const IDLE = "Idle"
const MOVING = "Moving"
const LUNGING = "Lunging"
const POSSESSING = "Possessing"
const DEAD = "Dead"

func _ready() -> void:
	await owner.ready
	entity = owner as Player
	assert(entity != null, "The PlayerState state type must be used only in the entity scene. It needs the owner to be a Entity node.")
