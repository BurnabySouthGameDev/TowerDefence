extends Node3D

var path: Array[Vector3i]

func _ready() -> void:
	#Enemy will move to each of these points from top to bottom
	path.append(Vector3i(-4.35, 2, 0))
	path.append(Vector3i(-4.35, 2, -6.5))
	path.append(Vector3i(5.32, 2, -6.5))
	path.append(Vector3i(5.32, 2, 0))
	path.append(Vector3i(14.35, 2, 0))
	print(path)

func _process(delta: float) -> void:
	#Makes the enemy move to each point
	#Speed can be adjusted with the float in the move_toward method
	if path.is_empty():
		return
	else:
		var target_position = path.front()
		global_position = global_position.move_toward(target_position, 0.05)
		if global_position.is_equal_approx(target_position):
			path.pop_front()
