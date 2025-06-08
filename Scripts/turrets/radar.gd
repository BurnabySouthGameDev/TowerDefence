extends Area3D
class_name Radar

@onready
var cooldown_timer : Timer = $"Timer"

var body_count := 0

var current_target : PathFollow3D = null:
	set(value):
		if (current_target != value):
			current_target = value
			new_target.emit(current_target)

signal new_target(target: PathFollow3D)

func _on_area_entered(body: Area3D) -> void:
	var enemy : PathFollow3D = body.get_parent()
	print("enter range: ", enemy)
	body_count += 1
	if body_count == 1:
		cooldown_timer.start()
		current_target = enemy

func _on_area_exited(body: Area3D) -> void:
	var enemy : PathFollow3D = body.get_parent()
	print("exit range: ", enemy)
	body_count -= 1
	if body_count == 0:
		cooldown_timer.stop()
		current_target = null
		return

	if current_target == enemy:
		current_target = null
		recalculate_target()

func recalculate_target() -> void:
	if current_target == null and body_count == 0:
		return

	if is_valid_target(current_target):
		return

	for area in get_overlapping_areas():
		var enemy : PathFollow3D = area.get_parent()
		if is_valid_target(enemy):
			current_target = enemy
			return

	current_target = null

func is_valid_target(target: Node3D) -> bool:
	return (target != null and is_instance_valid(target) and not target.is_queued_for_deletion()
		# check if in range perhaps? would require raycasts.
	)
