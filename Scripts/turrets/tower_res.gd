extends Resource
class_name TowerResource

signal radius_changed(value)

@export_group("General")
@export var tower_name: String
@export var damage: int
@export var attack_speed: float
@export var radius: int:
	set(value):
		if radius != value:
			radius = value
			radius_changed.emit(value)
@export var sell_value: int

@export_group("Upgrades")
@export var number_of_upgrades: int
@export var upgrades: Array[UpgradeResource] = []
