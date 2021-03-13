extends Node2D


func _ready():
	EgoVenture.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_upper_boiler_room_cl.ogg"))
	EgoVenture.target_view = "left"
	EgoVenture.change_scene("res://scenes/man/man11.tscn")
