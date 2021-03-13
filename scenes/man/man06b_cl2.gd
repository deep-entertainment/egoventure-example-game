extends Node2D


func _ready():
	EgoVenture.check_cursor()


func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_op.ogg"))
	EgoVenture.change_scene("res://scenes/man/man06b_cl2_op.tscn")

