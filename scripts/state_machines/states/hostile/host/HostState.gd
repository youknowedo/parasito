class_name HostState extends HostileState

const P_IDLE = "PIdle"
const P_MOVING = "PMoving"
const DASHING = "Dashing"

var host: Host

func _ready() -> void:
	await owner.ready
	host = owner as Host
	assert(host != null, "The HostState state type must be used only in the host scene. It needs the owner to be a Host node.")
	_on_ready()

func _on_ready() -> void:
	pass
