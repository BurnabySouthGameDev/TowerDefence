extends Node

@export
var turrets : Array[TowerResource] = []

func _ready() -> void:
	assert(turrets != null)
	for turret in turrets:
		assert(turret != null)
