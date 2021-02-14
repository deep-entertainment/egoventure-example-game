extends Node2D



func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_outer_door_op.ogg"))
