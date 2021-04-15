extends Node2D

func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_kitchen_door_cl.ogg"))
	EgoVenture.target_view = "right"
	EgoVenture.change_scene("res://scenes/man/man07.tscn")

