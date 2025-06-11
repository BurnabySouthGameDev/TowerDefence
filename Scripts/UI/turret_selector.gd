extends ItemList

signal turret_selected(listing: TowerResource)

func _ready() -> void:
	reload()

func reload() -> void:
	clear()

	for listing in TurretList.turrets:
		add_item(listing.tower_name, null)

func _on_item_activated(index: int) -> void:
	assert(index < TurretList.turrets.size())

	turret_selected.emit(TurretList.turrets[index])
	deselect_all()
