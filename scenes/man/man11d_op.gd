extends Node2D

func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_upper_boiler_room_cl.ogg"))
	EgoVenture.target_view = "left"
	EgoVenture.change_scene_to_file("res://scenes/man/man11.tscn")
