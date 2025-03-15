class_name GruntState extends HostState

var grunt: Grunt

func _on_ready():
	grunt = entity as Grunt
	assert(grunt != null, "The GruntState state type must be used only in the entity scene. It needs the owner to be a Grunt node.")
