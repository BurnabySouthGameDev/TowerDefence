extends PathFollow3D

var path: Array[Vector3i]
@onready var progress_bar: ProgressBar = $enemy/HealthBar/ProgressBar

var wave_number = Global.wave_number
@export var speed: float = 5
@export var health: float = 50:

	set(value):
		health = value
		progress_bar.value = health

func _ready() -> void:
	assert(get_parent() is Path3D)
	#Health scaling based on waves
	health = 50*((1.1)**(1.4*wave_number))
	progress_bar.max_value = health
	progress_bar.value = health

func _process(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1.0:
		# Later can add some thing like - 10 HP
		var currency_label = get_tree().root.get_node("Main/GameUI/TopBar/HBoxContainer/CurrencyDisplay/MarginContainer/CurrencyLabel")
		currency_label.subtract(50)
		Global.emit_signal("set_lives", -1)
		#print("enemy reached the end of the path")
		queue_free()

func take_damage(amount: float) -> float:
	health -= amount
	return health
