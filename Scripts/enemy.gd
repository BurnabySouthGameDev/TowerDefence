extends PathFollow3D

var path: Array[Vector3i]
@onready var progress_bar: ProgressBar = $enemy/HealthBar/ProgressBar


@export var speed: float = 0.5
@export var health: float = 20:
	set(value):
		health = value

		if health <= 0:
			queue_free()
			return

		progress_bar.value = health

func _ready() -> void:
	assert(get_parent() is Path3D)

func _process(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1.0:
		# Later can add some thing like - 10 HP
		var currency_label = get_tree().root.get_node("Main/GameUI/CurrencyDisplay/CurrencyLabel")
		currency_label.subtract(50)
		print("ememy reach the end of the path")
		queue_free()

func take_damage(amount: float) -> float:
	health -= amount
	return health
