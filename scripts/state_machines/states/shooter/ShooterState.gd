class_name ShooterState extends HostState

var grunt: Shooter

func _on_ready():
	grunt = entity as Shooter
	assert(grunt != null, "The ShooterState state type must be used only in the entity scene. It needs the owner to be a Shooter node.")
