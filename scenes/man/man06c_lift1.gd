extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_test_op.ogg"))
	MdnaCore.change_scene("res://scenes/man/man06c_lift2.tscn")
