extends Area3D

const OUTLINE = preload("res://Shaders/outline.gdshader")
@onready var basic_turret: Node3D = $".."
@onready var csg_box_3d: CSGBox3D = %CSGBox3D


func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicked turret:", basic_turret.name)
		basic_turret.emit_signal("request_tower_menu", basic_turret)

		if csg_box_3d.material.next_pass.shader == null:
			basic_turret.selected = true
		else:
			basic_turret.selected = false
