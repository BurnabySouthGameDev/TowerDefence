extends Node3D

func _ready() -> void:
	Global.connect("change_map", change_map)

func change_map(map: PackedScene) -> void:
	if get_child(0) != null:
		get_child(0).queue_free()

	var map_inst := map.instantiate()
	add_child(map_inst)
