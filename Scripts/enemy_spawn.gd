extends Marker3D

var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
var spawned_number = 0

# Config
@export var path: Path3D

@onready var enemy_spawn: Marker3D = self
@onready var spawn_timer: Timer = Timer.new()

func _ready() -> void:
	# Setup timer
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.connect("timeout", Callable(self, "spawn_enemy"))
	start_spawn_timer()

func spawn_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	path.add_child(enemy_instance)
	# enemy_instance.global_position = enemy_spawn.global_position
	spawned_number += 1
	print("spawned enemy number: %d" % spawned_number)
	start_spawn_timer()

func start_spawn_timer() -> void:
	# Spawne time between 0.5-2.0s.
	var wait_time = randf_range(0.5, 2.0)
	spawn_timer.start(wait_time)
