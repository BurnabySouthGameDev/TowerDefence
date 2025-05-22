extends Node3D

signal tower_menu(turret:Node3D) #fires when a child is added


func _on_child_entered_tree(tower: Node3D) -> void:
	if tower.has_signal("request_tower_menu"):
		tower.connect("request_tower_menu", Callable(self, "_on_child_selected"))


func _on_child_selected(tower:Node3D) -> void:
	emit_signal("tower_menu", tower)
