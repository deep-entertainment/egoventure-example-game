extends Node2D

func _on_Hotspot_activate():
	(EgoVenture.state as GameState).screwdr_hs = true
	Boombox.play_effect(preload("res://sounds/man/man_file_inv.ogg"))
	Inventory.add_item(preload("res://inventory/screwdriver.tres"))
	Notepad.finished_step(3, 2)
	EgoVenture.change_scene_to_file("res://scenes/man/man12f_lift1.tscn")
