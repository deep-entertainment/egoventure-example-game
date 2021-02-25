extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_matchkey_up.ogg"))
	(MdnaCore.state as GameState).use_info_will_be_seen = 1
	MdnaCore.change_scene("res://scenes/man/man09c_cl2_lift3.tscn")
