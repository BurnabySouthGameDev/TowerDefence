extends Button

signal menuInteract(button_name)  # Signal with an argument

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	emit_signal("menuInteract", self.name)  # Emit signal with the button's name
