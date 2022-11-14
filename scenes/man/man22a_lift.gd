extends Node2D

func _on_Hotspot_activate():
	if (EgoVenture.state as GameState).inv_info_seen == 1:
		(EgoVenture.state as GameState).man_rag = true
		Boombox.play_effect(preload("res://sounds/man/man_file_inv.ogg"))
		Inventory.add_item(preload("res://inventory/file.tres"))
		Notepad.finished_step(4, 1)
		EgoVenture.change_scene_to_file("res://scenes/man/man22a_cl.tscn")
	else:
		(EgoVenture.state as GameState).man_rag = true
		Boombox.play_effect(preload("res://sounds/man/man_file_inv.ogg"))
		Inventory.add_item(preload("res://inventory/file.tres"))
		Notepad.finished_step(4, 1)
		(EgoVenture.state as GameState).inv_info_seen = 1
		EgoVenture.change_scene_to_file("res://scenes/man/man22a_inf.tscn")
