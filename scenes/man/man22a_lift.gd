extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	(MdnaCore.state as GameState).man_rag = true
	Boombox.play_effect(preload("res://sounds/man/man_file_inv.ogg"))
	MdnaInventory.add_item(preload("res://inventory/file.tres"))
	MdnaCore.change_scene("res://scenes/man/man22a_cl.tscn")
