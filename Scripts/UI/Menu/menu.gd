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
@onready var damage: RichTextLabel = %Damage
@onready var attack_speed: RichTextLabel = %AttackSpeed
@onready var radius: RichTextLabel = %Radius



func _ready() -> void:
	hide()


func _on_tower_manager_tower_menu(tower: Node3D) -> void:
	if Global.selected_tower == tower:
		hide()

	else:
		show()
		_load_values(tower.resource)
		menu_sell_value = tower.sell_value


func _on_sell_button_pressed() -> void:
	currency_label.add(menu_sell_value)
	Global.placed_turrets.erase(Global.selected_tower)
	Global.selected_tower.queue_free()
	hide()

func _load_values(res:TowerResource) -> void: #not sure how to fit for upgrades
	if res.number_of_upgrades == 0:
		tower_name.text = "[center]" + res.tower_name
		menu_sell_value = res.base_sell_value
		damage.text = "Damage: " + str(res.base_damage)
		attack_speed.text = "Attack Speed: " + str(res.base_attack_speed)
		radius.text = "Radius: " + str(res.base_radius)
		
