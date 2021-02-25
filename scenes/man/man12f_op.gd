extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_up.ogg"))
	MdnaCore.change_scene("res://scenes/man/man12f_lift0.tscn")
