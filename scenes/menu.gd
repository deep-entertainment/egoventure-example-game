extends Control

func _ready():
	MdnaInventory.disable()
	MainMenu.toggle()
	MainMenu.saveable = false
