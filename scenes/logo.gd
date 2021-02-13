


extends Control

func _ready():
	MdnaInventory.disable()

func to_menu():
	MdnaCore.change_scene("res://scenes/menu.tscn")
