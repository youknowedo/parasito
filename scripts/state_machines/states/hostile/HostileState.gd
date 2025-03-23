class_name HostileState extends State

const ROAMING = "Roaming"
const CHASING = "Chasing"
const ATTACKING = "Attacking"

var hostile: Hostile

func _ready() -> void:
	await owner.ready
	hostile = owner as Hostile
	assert(hostile != null, "The HostileState state type must be used only in the hostile scene. It needs the owner to be a Hostile node.")
	_on_ready()

func _on_ready() -> void:
	pass
