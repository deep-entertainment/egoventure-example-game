extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_insex_inv.ogg"))
	MdnaInventory.add_item(preload("res://inventory/insex.tres"))
	(MdnaCore.state as GameState).hs_on_ins = true
	MdnaCore.target_view = "back"
	MdnaCore.change_scene("res://scenes/man/man12.tscn")