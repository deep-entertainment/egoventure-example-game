extends Node2D

func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_matchkey_up.ogg"))
	(EgoVenture.state as GameState).use_info_will_be_seen = 1
	EgoVenture.change_scene_to_file("res://scenes/man/man09c_cl2_lift3.tscn")
