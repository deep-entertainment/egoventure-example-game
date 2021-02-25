extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_upper_boiler_room_cl.ogg"))
	MdnaCore.target_view = "left"
	MdnaCore.change_scene("res://scenes/man/man11.tscn")
