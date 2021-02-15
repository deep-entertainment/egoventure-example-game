extends Node2D


func _ready():
	pass


func _on_Hotspot4_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_kitchen_door_op.ogg"))
	MdnaCore.change_scene("res://scenes/man/man07b_op.tscn")


func _on_Hotspot5_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_skarbrade_up.ogg"))
	MdnaCore.change_scene("res://scenes/man/man07b_lift1.tscn")
