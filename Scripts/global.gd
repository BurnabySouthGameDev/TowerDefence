extends Node

##VARIABLES
var selected_tower: Node3D = null:
	set(value):
		if selected_tower == value:
			return

		if selected_tower != null:
			selected_tower.selected = false

		selected_tower = value

var selectable_tower: Node3D = null:
	set(value):
		if selectable_tower == value:
			return

		selectable_tower = value

var placed_turrets: Array[Node3D] = []

var wave_number = 10

##SIGNALS
signal set_lives(value: int) #not actually set cant find a name
