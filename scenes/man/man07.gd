extends Node2D


func _ready():
	pass


func _on_Hotspot5_activate():
	Boombox.play_effect(preload("res://sounds/man/man_skarbrade_up.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man07b_lift1.tscn")



func _on_Hotspot4_activate():
	Boombox.play_effect(preload("res://sounds/man/man_kitchen_door_op.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man07b_op.tscn")
