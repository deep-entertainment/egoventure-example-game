extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	(MdnaCore.state as GameState).man_rag = true
	MdnaInventory.add_item(preload("res://inventory/rag.tres"))
	MdnaCore.change_scene("res://scenes/man/man22a_cl.tscn")
