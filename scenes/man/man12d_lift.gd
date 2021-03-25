extends Node2D


func _ready():
	EgoVenture.check_cursor()





func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_insex_inv.ogg"))
	Inventory.add_item(preload("res://inventory/insex.tres"))
	(EgoVenture.state as GameState).hs_on_ins = true
	EgoVenture.target_view = "back"
	Notepad.finished_step(2, 3)
	EgoVenture.change_scene("res://scenes/man/man12.tscn")
