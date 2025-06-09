extends Marker3D

var health = 100
@onready var base_health_label: Label = $"BaseHealth Label"

func _ready() -> void:
	connect("damagebase", take_damage)

func take_damage(amount): 
	health -= amount

func _process(delta: float) -> void:
	base_health_label.text = str("Base Health: "+ str(health))
	if health <= 0: 
		print("Game Over")
		get_tree().paused = true
