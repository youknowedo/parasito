class_name HostState extends State

const ROAMING = "Roaming"
const CHASING = "Chasing"
const ATTACKING = "Attacking"
const DEAD = "Dead"
const P_IDLE = "PIdle"
const P_MOVING = "PMoving"

var entity: Host

func _ready() -> void:
	await owner.ready
	entity = owner as Entity
	assert(entity != null, "The HostState state type must be used only in the entity scene. It needs the owner to be a Host node.")
	_on_ready()

func _on_ready() -> void:
	pass
