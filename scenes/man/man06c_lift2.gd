extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_test_back.ogg"))
	MdnaCore.change_scene("res://scenes/man/man06c_op.tscn")

