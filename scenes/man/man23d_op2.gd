extends Node2D

func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))


func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_bath_cupb_cl.ogg"))
	EgoVenture.target_view = "left"
	EgoVenture.change_scene_to_file("res://scenes/man/man23.tscn")
