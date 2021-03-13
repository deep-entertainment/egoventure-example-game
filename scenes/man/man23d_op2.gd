extends Node2D


func _ready():
	EgoVenture.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_bath_cupb_cl.ogg"))
	EgoVenture.target_view = "left"
	EgoVenture.change_scene("res://scenes/man/man23.tscn")



func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
