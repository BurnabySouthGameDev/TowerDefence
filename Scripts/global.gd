extends Node

var selected_turret: Node3D:
	set(value):
		if value == selected_turret:
			return
		if selected_turret != null:
			selected_turret.selected = false
		selected_turret = value
