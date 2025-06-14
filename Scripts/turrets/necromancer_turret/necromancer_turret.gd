extends "res://Scripts/turrets/basic_turret.gd"

@export_range(1, 10, 1, "or_greater")
var max_zombie_count := 3

@export
var zombie_damage := 7

var zombies : Array[PathFollow3D] = []

@onready var convert = preload("res://Audio/Necromancer_Converted.wav")

func _on_hit_enemy(enemy: PathFollow3D) -> void:
	if enemy.health <= 0:
		get_node("/root/Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel").add(5)
		if zombies.size() >= max_zombie_count:
			enemy.queue_free()
			return

		assert(not enemy.is_queued_for_deletion())
		assert(enemy.is_processing())
		zombies.push_back(enemy)

		# This only disables the '_process' function of only the PathFollow (enemy) node .
		enemy.set_process(false)
		var parent := enemy.get_parent()
		var enemy_position := enemy.global_position
		parent.remove_child(enemy)

		var max_health : float = enemy.get_node("enemy/HealthBar/ProgressBar").max_value
		max_health = max_health * 1.5
		enemy.get_node("enemy/HealthBar/ProgressBar").max_value = max_health
		enemy.health = max_health
		var area : Area3D = enemy.get_node("enemy")
		assert(not area.is_queued_for_deletion())
		area.position += Vector3.RIGHT * 0.75
		area.monitoring = true
#		area.monitorable = false
		area.set_deferred("monitorable", false)
		area.collision_layer = 0
		area.collision_mask = 0b0_0010
		area.area_entered.connect(_on_zombie_hit_enemy.bind(enemy))

		parent.add_child(enemy, false, INTERNAL_MODE_FRONT)
		
		$AudioPlayer.play_sound(convert)

func _on_zombie_hit_enemy(area: Area3D, zombie: PathFollow3D) -> void:
	var enemy : PathFollow3D = area.get_parent()
	var remaining_hp : float = enemy.take_damage(zombie_damage)
	if remaining_hp <= 0:
		get_node("/root/Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel").add(5)
		enemy.queue_free()
		$AudioPlayer.play_sound(destroy)

	remaining_hp = zombie.take_damage(zombie_damage / 2.0)
	if remaining_hp <= 0:
		zombies.erase(zombie)
		zombie.queue_free()

func _process(delta: float) -> void:
	for zombie in zombies:
		assert(zombie != null)
		assert(is_instance_valid(zombie))

		zombie.rotate(Vector3.UP, 2 * delta)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for zombie in zombies:
			zombie.queue_free()
