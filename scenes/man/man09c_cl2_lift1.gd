extends Node2D


func _ready():
	MdnaCore.check_cursor()
	(MdnaCore.state as GameState).match_takeable = true


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_matches_op.ogg"))
	MdnaCore.change_scene("res://scenes/man/man09c_cl2_lift2.tscn")
