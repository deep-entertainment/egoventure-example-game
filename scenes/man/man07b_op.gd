extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_kitchen_door_cl.ogg"))
	MdnaCore.target_view = "right"
	MdnaCore.change_scene("res://scenes/man/man07.tscn")
