extends Resource
class_name TowerResource

@export_group("General")
@export var tower_name: String
@export var base_damage: int
@export var base_attack_speed: int
@export var base_radius: int
@export var base_sell_value: int

@export_group("Upgrades")
@export var number_of_upgrades: int
@export var upgrades: Array[UpgradeResource] = []
