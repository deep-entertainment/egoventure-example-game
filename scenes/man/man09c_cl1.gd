extends Node2D


func _ready():
	EgoVenture.check_cursor()


func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_book_up.ogg"))
	EgoVenture.change_scene("res://scenes/man/man09c_lift1.tscn")

