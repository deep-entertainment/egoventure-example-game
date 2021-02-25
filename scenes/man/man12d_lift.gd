extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_insex_inv.ogg"))
	MdnaInventory.add_item(preload("res://inventory/insex.tres"))
	(MdnaCore.state as GameState).hs_on_ins = true
	MdnaCore.target_view = "back"
	Notepad.finished_step(2, 3)
	MdnaCore.change_scene("res://scenes/man/man12.tscn")
