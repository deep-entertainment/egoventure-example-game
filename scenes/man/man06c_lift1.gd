extends Node2D

func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_test_op.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man06c_lift2.tscn")
