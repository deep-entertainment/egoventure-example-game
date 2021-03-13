extends Node2D


func _ready():
	EgoVenture.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_matches_op.ogg"))
	EgoVenture.change_scene("res://scenes/man/man09c_cl2_lift5.tscn")
