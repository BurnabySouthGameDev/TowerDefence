extends PathFollow3D

var path: Array[Vector3i]
@onready var progress_bar: ProgressBar = $enemy/HealthBar/ProgressBar


@export var speed: float = 0.5
@export var health: int = 20:
	set(value):
		if health == value:
			return

		health = value

		if health <= 0:
			queue_free()
			return

		progress_bar.value = health

func _ready() -> void:
	#Enemy will move to each of these points from top to bottom
	path.append(Vector3i(-4.35, 2, 0))
	path.append(Vector3i(-4.35, 2, -6.5))
	path.append(Vector3i(5.32, 2, -6.5))
	path.append(Vector3i(5.32, 2, 0))
	path.append(Vector3i(14.35, 2, 0))
	print(path)
	assert(get_parent() is Path3D)

func _process(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1.0:
		# Later can add some thing like - 10 HP
		var currency_label = get_tree().root.get_node("Main/GameUI/CurrencyDisplay/MarginContainer/CurrencyLabel")
		currency_label.subtract(50)
		Global.emit_signal("set_lives", -1)
		print("ememy reach the end of the path")
		queue_free()

func take_damage(amount: int) -> void:
	health -= amount
