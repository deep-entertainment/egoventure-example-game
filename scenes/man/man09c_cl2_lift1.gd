extends Node2D


func _ready():
	EgoVenture.check_cursor()
	(EgoVenture.state as GameState).match_takeable = true



func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_matches_op.ogg"))
	EgoVenture.change_scene("res://scenes/man/man09c_cl2_lift2.tscn")
