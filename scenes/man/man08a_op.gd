extends Node2D


func _ready():
	Boombox.play_background(preload("res://sounds/man/home_fridge_bg.ogg")) 






func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_fridge_cl.ogg"))
	Boombox.stop_background()
	EgoVenture.target_view = "front"
	EgoVenture.change_scene("res://scenes/man/man08.tscn")
