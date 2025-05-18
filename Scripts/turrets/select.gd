extends Area3D

const OUTLINE = preload("res://Shaders/outline.gdshader")
@onready var basic_turret: Node3D = $".."


@onready var csg_box_3d: CSGBox3D = %CSGBox3D


func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicked turret")

		if csg_box_3d.material.next_pass.shader == null:
			basic_turret.selected = true
		else:
			basic_turret.selected = false
