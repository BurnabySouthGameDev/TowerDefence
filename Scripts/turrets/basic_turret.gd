extends Node3D

const OUTLINE = preload("res://Shaders/outline.gdshader")
signal request_tower_menu(tower)

@export var sell_value: int = 5
@export var resource: TowerResource

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
		else:
			csg_box_3d.material.next_pass.shader = null
			Global.selected_tower = null

@onready var radar: Radar = $"Radar"
@onready var reload_timer: Timer = $"ReloadTimer"
@onready var csg_box_3d: CSGBox3D = %CSGBox3D

func _ready() -> void:
	radar.monitoring = false
	csg_box_3d.material = csg_box_3d.material.duplicate(true)
	resource.radius_changed.connect(update_radius)


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

	reload_timer.wait_time = resource.attack_speed
	print(resource.attack_speed)

func _fire_at(target: Node3D) -> void:
	var target_pos = target.global_position
	target_pos.y = global_position.y  # Flatten Y to prevent pitch/roll
	look_at(target_pos, Vector3.UP)

	target.get_parent().take_damage(resource.damage)

	if target.get_parent().health <= 0:
		var currency_label: Label = get_tree().root.get_node("Main/GameUI/CurrencyDisplay/CurrencyLabel")
		currency_label.add(5)
		target.get_parent().queue_free()

func change_color(color: Color) -> void:
	if csg_box_3d.material == null:
		return

	csg_box_3d.material = csg_box_3d.material.duplicate()
	csg_box_3d.material.albedo_color = color

func update_radius(value: int) -> void:
	$Radar/CollisionShape3D.shape.radius = value
