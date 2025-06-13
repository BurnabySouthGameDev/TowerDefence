extends Button

@export var map_scene: PackedScene

func _on_pressed() -> void:
	get_tree().current_scene.get_node("GameUI/MainMenu").hide()
	Global.emit_signal("change_map", map_scene)
