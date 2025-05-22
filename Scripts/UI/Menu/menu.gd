extends PanelContainer

var menu_sell_value: int:
	set(value):
		if menu_sell_value == value:
			return
		menu_sell_value = value
		sell_button.text = "Sell for " + str(value)

@onready var tower_name: RichTextLabel = %TowerName
@onready var sell_button: Button = %SellButton
@onready var currency_label: Label = $"../CurrencyDisplay/CurrencyLabel"


func _ready() -> void:
	hide()


func _on_tower_manager_tower_menu(tower: Node3D) -> void:
	if Global.selected_tower == tower:
		hide()
	else:
		show()
		tower_name.text = "[center]" + tower.name
		menu_sell_value = tower.sell_value


func _on_sell_button_pressed() -> void:
	currency_label.add(menu_sell_value)
	Global.placed_turrets.erase(Global.selected_tower)
	Global.selected_tower.queue_free()
	hide()
	
