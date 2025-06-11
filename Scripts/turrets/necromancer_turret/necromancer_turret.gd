extends "res://Scripts/turrets/basic_turret.gd"

@export_range(1, 10, 1, "or_greater")
var max_zombie_count := 3

@export
var zombie_damage := 7

var zombies : Array[PathFollow3D] = []

func _on_hit_enemy(enemy: PathFollow3D) -> void:
	if enemy.health <= 0:
		get_node("/root/Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel").add(5)
		if zombies.size() >= max_zombie_count:
			enemy.queue_free()
			return

		zombies.push_back(enemy)

		# This only disables the '_process' function of only the PathFollow (enemy) node .
		enemy.set_process(false)
		var parent := enemy.get_parent()
		parent.remove_child(enemy)
		parent.add_child(enemy, false, INTERNAL_MODE_FRONT)

		var max_health : float = enemy.get_node("enemy/HealthBar/ProgressBar").max_value
		max_health = max_health * 3
		enemy.get_node("enemy/HealthBar/ProgressBar").max_value = max_health
		enemy.health = max_health
		var area : Area3D = enemy.get_node("enemy")
		area.monitoring = true
		area.collision_layer = 0
		area.collision_mask = 0b0_0010
		area.area_entered.connect(_on_zombie_hit_enemy.bind(enemy))

func _on_zombie_hit_enemy(area: Area3D, zombie: PathFollow3D) -> void:
	var enemy : PathFollow3D = area.get_parent()
	var remaining_hp : float = enemy.take_damage(zombie_damage)
	if remaining_hp <= 0:
		get_node("/root/Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel").add(5)
		enemy.queue_free()

	remaining_hp = zombie.take_damage(zombie_damage / 2.0)
	if remaining_hp <= 0:
		zombie.queue_free()
		zombies.remove_at(zombies.find(zombie))
