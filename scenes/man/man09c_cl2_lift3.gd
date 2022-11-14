extends Node2D

func _on_Hotspot_activate():
	if (EgoVenture.state as GameState).inv_info_seen == 1:
		Boombox.play_effect(preload("res://sounds/man/man_matchkey_inv.ogg"))
		Inventory.add_item(preload("res://inventory/matchkey.tres"))
		Notepad.finished_step(2, 1)
		EgoVenture.change_scene_to_file("res://scenes/man/man09c_cl2_lift4.tscn")
	else:
		Boombox.play_effect(preload("res://sounds/man/man_matchkey_inv.ogg"))
		Inventory.add_item(preload("res://inventory/matchkey.tres"))
		Notepad.finished_step(2, 1)
		(EgoVenture.state as GameState).inv_info_seen = 1
		EgoVenture.change_scene_to_file("res://scenes/man/man09c_cl2_lift4_inf.tscn")
