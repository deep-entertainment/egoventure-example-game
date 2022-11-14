extends Node2D


func _ready():
	pass
	
	
func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_bath_door_op.ogg"))
	EgoVenture.target_view = "front"
	EgoVenture.change_scene_to_file("res://scenes/man/man23.tscn")




func _on_Hotspot3_activate():
	Boombox.play_effect(preload("res://sounds/man/man_fridge_op.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man08a_op.tscn")
