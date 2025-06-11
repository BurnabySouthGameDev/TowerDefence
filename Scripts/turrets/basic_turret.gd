extends Node3D

const OUTLINE = preload("res://Shaders/outline.gdshader")
signal request_tower_menu(tower)

@onready var rad_indicator = $RadiusIndicator

@export var sell_value: int = 5

@export_subgroup("bullet")
@export_range(0.01, 10, 0.01, "or_greater", "hide_slider")
var bullet_speed := 10.0

@export_range(0.01, 10, 0.01, "or_greater", "hide_slider")
var bullet_range := 5.0

@export
var bullet_scene : PackedScene = null

@export_range(0, 10, 1, "or_greater")
var bullet_pierce := 0

var listing: TowerResource = null

var selectable: bool = false:
	set(value):
		if selectable == value:
			return

		selectable = value

		if selectable:
			Global.selectable_tower = self
		else:
			Global.selectable_tower = null

var selected: bool = false:
	set(value):
		if selected == value:
			return

		selected = value

		if selected:
			csg_box_3d.material.next_pass.shader = OUTLINE
			Global.selected_tower = self
		else:
			csg_box_3d.material.next_pass.shader = null
			Global.selected_tower = null

		emit_signal("request_tower_menu", self)

@onready var radar: Radar = $"Radar"
@onready var reload_timer: Timer = $"ReloadTimer"
@onready var csg_box_3d: CSGBox3D = %CSGBox3D
@onready var turret_cap : Node3D = $"TurretCap"

func _ready() -> void:
	csg_box_3d.material = csg_box_3d.material.duplicate(true)
	listing.radius_changed.connect(update_radius)
	reload_timer.start()
	reload_timer.paused = true


func _on_radar_new_target(target: PathFollow3D) -> void:
	if not radar.monitoring:
		return

	print("basic_turret - target: ", target)
	if target == null:
		return

	if reload_timer.paused:
		fire()
		reload_timer.paused = false

func fire() -> void:
	if radar.current_target == null:
		reload_timer.paused = true
	else:
		_fire_at(radar.current_target)

	reload_timer.wait_time = listing.attack_speed
	print(listing.attack_speed)

func _fire_at(target: PathFollow3D) -> void:
	var target_pos := target.global_position
	turret_cap.look_at(target_pos, Vector3.UP)

	var bullet : Node3D = bullet_scene.instantiate()
	bullet.position = turret_cap.position
	bullet.velocity = (target_pos - turret_cap.global_position).normalized() * bullet_speed
	bullet.lifetime = bullet_range / bullet_speed
	bullet.pierce = bullet_pierce
	bullet.damage = listing.damage
	bullet.hit_enemy.connect(_on_hit_enemy)

	add_child(bullet)

func _on_hit_enemy(enemy: PathFollow3D ) -> void:
	if enemy.health <= 0:
		get_node("/root/Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel").add(5)
		enemy.queue_free()

func get_color() -> Color:
	return Color.WHITE if csg_box_3d.material == null else csg_box_3d.material.albedo_color

func change_color(color: Color) -> void:
	if csg_box_3d.material == null:
		return
	csg_box_3d.material = csg_box_3d.material.duplicate()
	csg_box_3d.material.albedo_color = color

func change_indicator(color: Color) -> void:
	if rad_indicator.get_surface_override_material(0) == null:
		return
		
	rad_indicator.get_surface_override_material(0).set_shader_parameter("outer_color", color)
func indicator_visibility(is_vis: bool) -> void:
	rad_indicator.visible = is_vis
	
func update_radius(value: int) -> void:
	$Radar/CollisionShape3D.shape.radius = value
