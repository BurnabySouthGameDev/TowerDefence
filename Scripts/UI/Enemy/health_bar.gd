extends ProgressBar

var parent : Node3D

func _ready():
	parent = get_parent()
	if parent == null:
		push_error("Node %s: 3D to 2D failed! Parent is not a Node3D" % [name])

func _process(_dT):
	 # The added Vector is used to center the Control
	position = get_viewport().get_camera_3d().unproject_position(parent.global_position) + Vector2(-size.x/2, -20)
