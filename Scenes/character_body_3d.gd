extends CharacterBody3D

func _process(delta: float) -> void:
	velocity = Vector3(3, 0, 0)
	move_and_slide()
