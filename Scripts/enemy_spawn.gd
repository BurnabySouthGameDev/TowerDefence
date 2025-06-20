extends Marker3D

var difficulty_total = 0
var cap_reached: bool = true
var wave_number = Global.wave_number
var enemies: Dictionary
var enemykey: int
var enemy_to_spawn
var difficulty_cap = 3
var hordevar: float = 0

# Config
@onready var wave_counter: Label = $"../../../GameUI/TopBar/HBoxContainer/MarginContainer/WaveCounter"
@onready var enemy_spawn: Marker3D = self
@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy: PackedScene = preload("res://Scenes/Enemies/enemy.tscn")
@onready var enemy2: PackedScene = preload("res://Scenes/Enemies/enemy2.tscn")
@onready var horde_timer: Timer = $HordeTimer
@onready var path: Path3D = $"../Path/Path3D"
@onready var wave_start_button: Button = $"../../../GameUI/TopBar/HBoxContainer/MarginContainer/WaveStartButton"


func _ready() -> void:
	enemies = {
		1: {"Difficulty": 1,
		"Enemy": enemy},
		2: {"Difficulty": 2,
		"Enemy": enemy2},
	}
	wave_start_button.pressed.connect(_on_wave_start_button_pressed)

func _process(_delta: float) -> void:
	if difficulty_total >= difficulty_cap: 
		cap_reached = true
	#Checks if a wave has been cleared and shows the button if so
	if cap_reached == true and path.get_child_count() == 1:
		wave_start_button.visible = true
		wave_start_button.disabled = false
	if wave_start_button.visible == true:
		wave_counter.visible = false
	else:
		wave_counter.visible=true

func start_new_wave():
	wave_start_button.visible = false
	wave_start_button.disabled = true
	hordevar = 0
	cap_reached = false
	difficulty_total = 0
	wave_number += 1
	difficulty_cap = 3 + wave_number*2
	spawn_timer.start()
	wave_counter.text = str("Wave " + str(wave_number))

func spawn_enemy() -> void:
	#Spawns enemies when a horde is not activate
	if cap_reached == false and hordevar < 1: 
		var enemy_instance = enemy_to_spawn.instantiate()
		path.add_child(enemy_instance)
		difficulty_total += enemies[enemykey]["Difficulty"]
		spawn_timer.start()
	#Spawns hordes
	if hordevar >= 1 and cap_reached == false: 
		var enemy_instance = enemy_to_spawn.instantiate()
		path.add_child(enemy_instance)
		difficulty_total += enemies[enemykey]["Difficulty"]
		hordevar -= 1
		#Makes enemies spawn faster the higher the wave
		if 0.2-(wave_number/100) >= 0.025: 
			horde_timer.wait_time = 0.2-(wave_number/100)
		else: 
			horde_timer.wait_time = 0.025
		horde_timer.start()

func _on_timer_timeout() -> void:
	#Randomly selects an enemy
	var enemyarray: Array
	for i in enemies: 
		if enemies[i]["Difficulty"] + difficulty_total <= difficulty_cap:
			enemyarray.append(i)
	if enemyarray.is_empty() == false:
		enemykey = enemyarray.pick_random()
		roll_enemy()
	else: 
		return
	#Makes hordes more likely the higher the wave, guaranteed at 50
	var horderand = randi_range(1,-1/5 * wave_number + 6)
	if wave_number >= 25: 
		horderand = 1
	if horderand == 1: 
		hordevar = (wave_number/enemies[enemykey]["Difficulty"])-(wave_number/2)
		if hordevar >= 1: 
			print("Spawning Horde")

func roll_enemy():
	if difficulty_total < difficulty_cap: 
		enemy_to_spawn = enemies[enemykey]["Enemy"]
		spawn_enemy()

func _on_wave_start_button_pressed() -> void:
	start_new_wave()

func _on_horde_timer_timeout() -> void:
	spawn_enemy()
