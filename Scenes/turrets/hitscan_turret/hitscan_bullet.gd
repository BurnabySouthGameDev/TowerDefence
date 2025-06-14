extends Area3D

var damage := 0.0

var velocity := Vector3.ZERO

var lifetime := 0.0

var pierce := 0

signal hit_enemy(enemy: PathFollow3D)

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, ^"position", position + velocity * lifetime, lifetime)
	tween.tween_callback(queue_free)

func _on_area_entered(area: Area3D) -> void:
	var enemy : PathFollow3D = area.get_parent()
	assert(enemy != null)
	if enemy.health <= 0:
		return

	enemy.take_damage(damage)
	hit_enemy.emit(enemy)

	pierce -= 1
	if pierce < 0:
		queue_free()
