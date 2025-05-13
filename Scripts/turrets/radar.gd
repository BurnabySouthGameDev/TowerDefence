extends Area3D
class_name Radar

@onready
var cooldown_timer : Timer = $"Timer"

var body_count := 0

var current_target : Node3D = null:
	set(value):
		if (current_target != value):
			current_target = value
			new_target.emit(current_target)

signal new_target(target: Node3D)

func _on_body_entered(body: Node3D) -> void:
	print("enter range: ", body)
	body_count += 1
	if body_count == 1:
		cooldown_timer.start()
		current_target = body

func _on_body_exited(body: Node3D) -> void:
	print("exit range: ", body)
	body_count -= 1
	if body_count == 0:
		cooldown_timer.stop()
		current_target = null
		return

	if current_target == body:
		recalculate_target()

func recalculate_target() -> void:
	# temp solution for now.
	if (current_target == null and body_count == 0 or
		is_valid_target(current_target)):
		return

	for body in get_overlapping_bodies():
		if is_valid_target(body):
			current_target = body
			return

	current_target = null

func is_valid_target(target: Node3D) -> bool:
	return is_instance_valid(target) and not target.is_queued_for_deletion()
