extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_matchkey_inv.ogg"))
	MdnaInventory.add_item(preload("res://inventory/matchkey.tres"))
	MdnaCore.change_scene("res://scenes/man/man09c_cl2_lift4.tscn")
