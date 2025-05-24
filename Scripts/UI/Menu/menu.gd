extends PanelContainer

var tower_resource:TowerResource


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
		return

	show()
	_load_values(tower.resource)


func _on_sell_button_pressed() -> void:
	currency_label.add(tower_resource.sell_value)
	Global.placed_turrets.erase(Global.selected_tower)
	Global.selected_tower.queue_free()
	hide()


func _load_values(res:TowerResource) -> void:
	tower_resource = res
	tower_name.text = "[center]" + res.tower_name
	sell_button.text = str(res.sell_value)
	damage.text = str(res.damage)
	attack_speed.text = str(res.attack_speed)
	radius.text = str(res.radius)
	


func _on_upgrade_1_mouse_entered() -> void:
	if tower_resource.number_of_upgrades >= tower_resource.upgrades.size():
		return


func _on_u_1_button_pressed() -> void:
	if tower_resource.number_of_upgrades >= tower_resource.upgrades.size():
		return

	for i in tower_resource.upgrades[tower_resource.number_of_upgrades].stats:
		var stat_name = i[0]
		var value = i[1]
		var path = i[2]
		
		var node_path = path.slice(0, path.get_name_count())
		var property_path = path.slice(path.get_name_count())
		var node := self if node_path.is_empty() else get_node(node_path)

		tower_resource.set(stat_name, value)
		node.set_indexed(property_path, value)

	tower_resource.number_of_upgrades += 1
