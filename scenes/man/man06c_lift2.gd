extends Node2D


func _ready():
	(MdnaCore.state as GameState).man_folder_seen = 1


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_test_back.ogg"))
	MdnaCore.change_scene("res://scenes/man/man06c_op.tscn")

