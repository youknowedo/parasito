class_name GruntState extends State

const ROAMING = "Roaming"
const CHASING = "Chasing"
const ATTACKING = "Attacking"
const DEAD = "Dead"
const P_IDLE = "PIdle"
const P_MOVING = "PMoving"

var grunt: Grunt

func _ready() -> void:
	await owner.ready
	grunt = owner as Grunt
	assert(grunt != null, "The GruntState state type must be used only in the grunt scene. It needs the owner to be a Grunt node.")
