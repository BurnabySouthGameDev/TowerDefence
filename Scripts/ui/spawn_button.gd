extends Button

# Config
@export var min_distance: float = 2.5
@export var min_distance_path: float = 2.5
@onready var tower_manager: Node3D = %TowerManager

var turret_scene: PackedScene = preload("res://Scenes/turrets/basic_turret/basic_turret.tscn")
var placing_turret: Node3D = null

var can_place: bool = false: #temp
	set(value):
		if placing_turret == null:
			return

		if can_place == value:
			return

		can_place = value

		if can_place:
			placing_turret.change_color(Color(0.0863, 0.5411, 1.0))
		else:
			placing_turret.change_color(Color(0.7176, 0.2117, 0.1686))

@export var path_node: Path3D

@onready var cancel_button: Button = get_parent().get_node("CancelButton")

func _ready() -> void:
	connect("pressed", Callable(self, "start_placing_turret"))
	cancel_button.hide()
	cancel_button.connect("pressed", Callable(self, "cancel_placing_turret"))

func start_placing_turret() -> void:
	if placing_turret == null:
		placing_turret = turret_scene.instantiate()
		tower_manager.add_child(placing_turret)
		placing_turret.visible = false
		cancel_button.show()
		disabled = true

func cancel_placing_turret() -> void:
	if placing_turret:
		placing_turret.queue_free()
		placing_turret = null
	cancel_button.hide()
	disabled = false

func _process(_delta):
	if placing_turret == null:
		return

	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000

	var space_state = camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to

	var result = space_state.intersect_ray(query)

	if result and result.collider and result.collider.name == "Ground":
		placing_turret.global_position = result.position
		placing_turret.visible = true
	else:
		placing_turret.visible = false

	can_place = _can_place_turret_at(placing_turret.global_position)

func _unhandled_input(event):
	if placing_turret == null:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera := get_viewport().get_camera_3d()
		if camera == null:
			return

		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000

		var space_state = camera.get_world_3d().direct_space_state
		var query := PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to

		var result = space_state.intersect_ray(query)

		if result and result.collider and result.collider.name == "Ground":
			# Distance check between other turrets
			if not _can_place_turret_at(result.position):
				print("Invalid turret placement")
				return

			var currency_label = get_tree().root.get_node("Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel")
			if currency_label and currency_label.subtract(10):
				placing_turret.global_position = result.position

				var radar = placing_turret.get_node("Radar") as Radar
				radar.monitoring = true

				Global.placed_turrets.append(placing_turret)

				#placing_turret.selectable = true
				placing_turret = null
				cancel_button.hide()
				disabled = false
			else:
				print("No currency...")

func _can_place_turret_at(pos: Vector3) -> bool:
	for turret in Global.placed_turrets:
		if turret.global_position.distance_to(pos) < min_distance:
			print("Too close to another turret")
			return false

	if path_node and path_node.curve:
		var curve := path_node.curve
		var length := curve.get_baked_length()
		# Check every 1 meter along the path
		var interval := 1.0

		for distance in range(0, int(length), int(interval)):
			var path_pos := path_node.to_global(curve.sample_baked(distance))
			if pos.distance_to(path_pos) < min_distance_path:
				print("Too close to enemy path at %.2f meters" % distance)
				return false

	return true
