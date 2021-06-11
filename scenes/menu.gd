extends Control

func _ready():
	Inventory.disable()
	MainMenu.toggle()
	MainMenu.disabled = true
	MainMenu.saveable = false
	EgoVenture.check_cursor()
