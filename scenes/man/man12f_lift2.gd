extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	(MdnaCore.state as GameState).screwdr_hs = true
	Boombox.play_effect(preload("res://sounds/man/man_file_inv.ogg"))
	MdnaInventory.add_item(preload("res://inventory/screwdriver.tres"))
	MdnaCore.change_scene("res://scenes/man/man12f_lift1.tscn")
