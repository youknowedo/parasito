class_name PlayerState extends State

const IDLE = "Idle"
const MOVING = "Moving"
const LUNGING = "Lunging"
const POSSESSING = "Possessing"

var player: Entity

func _ready() -> void:
	await owner.ready
	player = owner as Entity
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Entity node.")
