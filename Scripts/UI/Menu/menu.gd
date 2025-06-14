extends PanelContainer

var tower_resource: TowerResource

@onready var tower_name: RichTextLabel = %TowerName
@onready var sell_button: Button = %SellButton
@onready var currency_label: Label = %CurrencyLabel
@onready var damage: RichTextLabel = %Damage
@onready var attack_speed: RichTextLabel = %AttackSpeed
@onready var radius: RichTextLabel = %Radius
@onready var upgrade_sound = preload("res://Audio/Upgrade_Turret.wav")


func _ready() -> void:
	hide()


func _open_menu(tower) -> void:
	if tower == Global.selected_tower:
		#print_rich("[color=red]Open")
		get_parent().get_node("SpawnButton").hide()
		show()
		_load_values(tower.listing)
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(get_tree().get_nodes_in_group("Camera")[0], "global_position", Vector3(tower.global_position.x + 5, tower.global_position.y + 5, tower.global_position.z), 0.5)
	else:
		#print_rich("[color=red]Close")
		get_parent().get_node("SpawnButton").show()
		hide()
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(get_tree().get_nodes_in_group("Camera")[0], "position", get_tree().get_nodes_in_group("CameraDefault")[0].position, 0.5)


func _sell() -> void:
	get_parent().get_node("SpawnButton").show()
	hide()
	currency_label.add(tower_resource.sell_value)
	Global.placed_turrets.erase(Global.selected_tower)
	Global.selected_tower.queue_free()
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(get_tree().get_nodes_in_group("Camera")[0], "position", get_tree().get_nodes_in_group("CameraDefault")[0].position, 0.5)


func _load_values(res:TowerResource) -> void: #loaded every selection
	tower_resource = res
	tower_name.text = "[center]" + res.tower_name
	sell_button.text = str(res.sell_value)
	damage.text = str(res.damage)
	attack_speed.text = str(res.attack_speed)
	radius.text = str(res.radius)


func _update() -> void:
	if tower_resource.number_of_upgrades >= tower_resource.upgrades.size():
		print("No more upgrades!")
		return

	for i in tower_resource.upgrades[tower_resource.number_of_upgrades].stats:
		var stat_name: String = i[0]
		var value: float = i[1]
		var path: NodePath = i[2]
		
		var node_path = path.slice(0, path.get_name_count())
		var property_path = path.slice(path.get_name_count())
		var node := self if node_path.is_empty() else get_node(node_path)

		tower_resource.set(stat_name, value)
		node.set_indexed(property_path, value)

	tower_resource.number_of_upgrades += 1
