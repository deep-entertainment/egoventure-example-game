extends Node2D

func _on_Hotspot2_activate():
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_op.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man06b_cl1_op.tscn")
