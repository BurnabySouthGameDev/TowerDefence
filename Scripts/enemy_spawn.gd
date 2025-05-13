extends Marker3D

var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
@export var Path: Path3D
@onready var enemy_spawn: Marker3D = $"."

func _ready() -> void:
	spawnenemy()

func _process(delta: float) -> void:
	pass

func spawnenemy():
	var enemy_instance = enemy_scene.instantiate()
	Path.add_child(enemy_instance)
	#enemy_instance.global_position = enemy_spawn.global_position
	print("spawned enemy")
