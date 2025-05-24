extends Node

var selected_tower: Node3D = null:
	set(value):
		if selected_tower == value:
			return

		if selected_tower != null:
			selected_tower.selected = false

		selected_tower = value

var placed_turrets: Array[Node3D] = []
