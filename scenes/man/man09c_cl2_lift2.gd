extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_matchkey_up.ogg"))
	MdnaCore.change_scene("res://scenes/man/man09c_cl2_lift3.tscn")
