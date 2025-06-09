extends Resource
class_name TowerResource

signal radius_changed(value)

@export var scene : PackedScene
@export var tower_name: String
@export var damage: float
@export var attack_speed: float
@export var radius: float:
	set(value):
		if radius != value:
			radius = value
			radius_changed.emit(value)
@export var sell_value: float

@export_group("Upgrades")
@export var number_of_upgrades: int
@export var upgrades: Array[UpgradeResource] = []

func instantiate() -> Node3D:
	var node: Node3D = scene.instantiate()
	node.listing = self
	return node
