extends Node3D

const OUTLINE = preload("res://Shaders/outline.gdshader")
signal request_tower_menu(tower)

var selectable: bool = false
var selected: bool = false:
	set(value):
		if selectable == false:
			return

		if selected == value:
			return

		selected = value

		if selected:
			csg_box_3d.material.next_pass.shader = OUTLINE
			Global.selected_tower = self
			#tower things go here
		else:
			csg_box_3d.material.next_pass.shader = null
			Global.selected_tower = null

@onready var radar: Radar = $"Radar"
@onready var reload_timer: Timer = $"ReloadTimer"
@onready var csg_box_3d: CSGBox3D = %CSGBox3D

func _ready() -> void:
	radar.monitoring = false
	csg_box_3d.material = csg_box_3d.material.duplicate(true)


func _on_radar_new_target(target: Node3D) -> void:
	if not radar.monitoring:
		return

	print("basic_turret - target: ", target)
	if target == null:
		reload_timer.stop()
		return

	if reload_timer.is_stopped():
		fire()
		reload_timer.start()

func fire() -> void:
	if radar.current_target != null:
		_fire_at(radar.current_target)

func _fire_at(target: Node3D) -> void:
	var target_pos = target.global_position
	target_pos.y = global_position.y  # Flatten Y to prevent pitch/roll
	look_at(target_pos, Vector3.UP)

	if randf() < (1.0 / 5.0):
		var currency_label = get_tree().root.get_node("Main/GameUI/CurrencyDisplay/CurrencyLabel")
		currency_label.add(5)
		target.queue_free()

func change_color(color:Color) -> void:
	if csg_box_3d.material == null:
		return

	csg_box_3d.material = csg_box_3d.material.duplicate()
	csg_box_3d.material.albedo_color = color
