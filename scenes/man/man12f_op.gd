extends Node2D

func _on_Hotspot2_activate():
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_up.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man12f_lift0.tscn")
