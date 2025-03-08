class_name ShooterState extends State

const ROAMING = "Roaming"
const CHASING = "Chasing"
const ATTACKING = "Attacking"
const DEAD = "Dead"
const P_IDLE = "PIdle"
const P_MOVING = "PMoving"

var shooter: Shooter

func _ready() -> void:
	await owner.ready
	shooter = owner as Shooter
	assert(shooter != null, "The GruntState state type must be used only in the shooter scene. It needs the owner to be a Grunt node.")
