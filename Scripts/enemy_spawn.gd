extends Marker3D

var enemy_scene: PackedScene = preload("res://Scenes/Enemies/enemy.tscn")
var enemy2_scene: PackedScene = preload("res://Scenes/Enemies/enemy2.tscn")
var difficulty_total = 0
var cap_reached: bool = true
var wave_number = 0
var enemies: Dictionary
var enemykey: int
var enemy_to_spawn
var difficulty_cap = 3

# Config
@onready var map: Node
@onready var path: Path3D
@onready var wave_counter: Label = $"../GameUI/WaveCounter"
@onready var enemy_spawn: Marker3D = self
#@onready var spawn_timer: Timer = Timer.new()
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	# Setup timer
	#spawn_timer.one_shot = true
	#add_child(spawn_timer)
	#spawn_timer.connect("timeout", Callable(self, "spawn_enemy"))
	map = get_parent().find_child("MapHolder").get_child(0)
	path = map.find_child("Path3D")
	start_new_wave()
	
	enemies = {#Make sure enemies are ordered lowest to highest difficulty
		0: {"Enemy": enemy_scene,
		"Difficulty": 1},
		1: {"Enemy": enemy2_scene,
		"Difficulty": 2},
	}

func _process(_delta: float) -> void:
	if difficulty_total >= difficulty_cap: 
		cap_reached = true
	#Checks if a wave has been cleared and starts a new one if so
	if cap_reached == true and path.get_child_count() == 1:
		start_new_wave()

func start_new_wave():
	cap_reached = false
	difficulty_total = 0
	wave_number += 1
	difficulty_cap = 3 + wave_number*2
	start_spawn_timer()
	wave_counter.text = str("Wave " + str(wave_number))

func spawn_enemy() -> void:
	if cap_reached == false: 
		var enemy_instance = enemy_to_spawn.instantiate()
		path.add_child(enemy_instance)
		# enemy_instance.global_position = enemy_spawn.global_position
		difficulty_total += enemies[enemykey]["Difficulty"]
	start_spawn_timer()

func start_spawn_timer() -> void:
	# Spawn time between 0.5-2.0s.
	#var wait_time = 0.75 #randf_range(0.5, 2.0) 
	spawn_timer.start()#wait_time)

func _on_timer_timeout() -> void:
	#The range should be adjusted based on the number of enemies
	enemykey = randi_range(0, 1)
	roll_enemy(enemykey)

func roll_enemy(enemykey):
	if difficulty_total < difficulty_cap: 
		enemy_to_spawn = enemies[enemykey]["Enemy"]
		if enemies[enemykey]["Difficulty"]+difficulty_total<=difficulty_cap:
			spawn_enemy()
		else: 
			enemykey -= 1
			roll_enemy(enemykey)
