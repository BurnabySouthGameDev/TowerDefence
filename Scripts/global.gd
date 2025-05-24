extends Node

var selected_tower: Node3D = null:
	set(value):
		if value == selected_tower:
			return
		
		if selected_tower != null:
			selected_tower.selected = false
		
		selected_tower = value
var placed_turrets: Array[Node3D] = []
