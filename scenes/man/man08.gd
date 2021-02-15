extends Node2D


func _ready():
	pass
	
	
func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_bath_door_op.ogg"))
	MdnaCore.target_view = "front"
	MdnaCore.change_scene("res://scenes/man/man23.tscn")


func _on_Hotspot3_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_fridge_op.ogg"))
	MdnaCore.change_scene("res://scenes/man/man08a_op.tscn")

