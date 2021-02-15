extends Control

func _ready():
	MdnaInventory.disable()
	MainMenu.toggle()
	MainMenu.disabled = true
	MainMenu.saveable = false
