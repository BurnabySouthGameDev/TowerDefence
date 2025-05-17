extends PathFollow3D

var path: Array[Vector3i]
@export var speed = 0.5
func _ready() -> void:
	#Enemy will move to each of these points from top to bottom
	path.append(Vector3i(-4.35, 2, 0))
	path.append(Vector3i(-4.35, 2, -6.5))
	path.append(Vector3i(5.32, 2, -6.5))
	path.append(Vector3i(5.32, 2, 0))
	path.append(Vector3i(14.35, 2, 0))
	print(path)

func _process(delta: float) -> void:
	if $".".get_parent() is Path3D and progress_ratio != 1:
		$".".progress += speed/10
		if progress_ratio >= 1.0:
			# Later can add some thing like - 10 HP
			var currency_label = get_tree().root.get_node("Main/GameUI/CurrencyDisplay/CurrencyLabel")
			currency_label.subtract(50)
			print("ememy reach the end of the path")
			queue_free()
	#else:
	#	get_tree().quit()
	
	# Unused for now
		
	#Makes the enemy move to each point
	#Speed can be adjusted with the float in the move_toward method
	#if path.is_empty():
	#	return
	#else:
	#	var target_position = path.front()
	#	global_position = global_position.move_toward(target_position, 0.05)
	#	if global_position.is_equal_approx(target_position):
	#		path.pop_front()
