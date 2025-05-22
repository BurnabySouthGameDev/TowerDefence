extends PanelContainer

@onready var tower_name: RichTextLabel = $TowerName

func _ready() -> void:
	hide()

func _on_tower_manager_tower_menu(tower: Node3D) -> void:
	if Global.selected_tower == tower:
		hide()
	else:
		show()
		tower_name.text = tower.name
