extends Node2D

func _on_Hotspot2_activate():
	Boombox.play_effect(preload("res://sounds/man/man_book_up.ogg"))
	EgoVenture.change_scene("res://scenes/man/man09c_lift1.tscn")
