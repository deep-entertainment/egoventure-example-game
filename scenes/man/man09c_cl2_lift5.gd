extends Node2D

func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_matches_back.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man09c_cl2.tscn")

