


extends Control

func _ready():
	MdnaInventory.disable()
	MainMenu.disabled = true

func to_menu():
	MainMenu.disabled = false
	MdnaCore.change_scene("res://scenes/menu.tscn")
