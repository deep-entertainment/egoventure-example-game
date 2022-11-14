extends Node2D

func _ready():
	(EgoVenture.state as GameState).raze_seen = 1



func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_green_book_cl.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man09c_lift1.tscn")

