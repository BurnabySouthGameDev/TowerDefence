extends PanelContainer

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var wave_counter: Label = %WaveCounter


var lives: int = 999999999:
	set(value):
		if lives == value:
			return

		if lives <= 0:
			print("Game over")
			wave_counter.text = "Game over"
			get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED

		lives = max(0, value)
		rich_text_label.text = "Lives: %d" % lives


func _ready() -> void:
	Global.connect("set_lives", func set_lives(value :int) -> void: lives += value)
	rich_text_label.text = "Lives: %d" % lives
