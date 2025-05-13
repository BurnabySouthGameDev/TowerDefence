extends Node3D

@onready
var radar : Radar = $"Radar"

@onready
var reload_timer : Timer = $"ReloadTimer"

func _on_radar_new_target(target: Node3D) -> void:
	print("basic_turret - target: ", target)
	if target == null:
		reload_timer.stop()
		return

	if reload_timer.is_stopped():
		fire()
		reload_timer.start()

func fire() -> void:
	assert(radar.current_target != null)

	_fire_at(radar.current_target)

func _fire_at(target: Node3D) -> void:
	var face := global_position.direction_to(target.global_position)
	quaternion = Quaternion(Vector3.FORWARD, face)
	if randf() < (1.0 / 5.0):
		target.queue_free()
