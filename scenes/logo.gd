
extends Control

func _ready():
	Speedy.hidden = true
	Inventory.disable()
	MainMenu.disabled = true
	await get_tree().create_timer(5).timeout
	MainMenu.disabled = false
	Speedy.hidden = false
	EgoVenture.change_scene_to_file("res://scenes/menu.tscn")


func _on_Hotspot_pressed():
	MainMenu.disabled = false
	Speedy.hidden = false
	EgoVenture.change_scene_to_file("res://scenes/menu.tscn")
