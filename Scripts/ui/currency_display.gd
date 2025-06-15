extends Label

# Config
@export var start_currency: int = 100

var currency: int = start_currency:
	set(value):
		currency = max(0, value)
		text = "💰: %d" % currency
		currency_changed.emit(currency)

signal currency_changed(amount: int)

func _ready() -> void:
	text = "💰: %d" % currency

func can_afford(amount: int) -> bool:
	return currency >= amount

func add(amount: int) -> void:
	currency += amount

func subtract(amount: int) -> bool:
	if can_afford(amount):
		currency -= amount
		return true
	return false
