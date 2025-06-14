extends Node3D

signal tower_menu(tower) #fires when a child is added


func _on_child_entered_tree(tower: Node3D) -> void:
	if tower.has_signal("request_tower_menu"):
		tower.connect("request_tower_menu", Callable(self, "_on_child_selected"))


func _on_child_selected(tower:Node3D) -> void:
	emit_signal("tower_menu", tower)

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Global.selected_tower != null and Global.selectable_tower == null:
		call_deferred("_deselect_tower")

func _deselect_tower() -> void:
	if Global.selected_tower != null:
		Global.selected_tower.selected = false
