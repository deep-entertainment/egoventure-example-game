extends Node2D


func _ready():
	pass


func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_bath_door_op.ogg"))
	EgoVenture.target_view = "right"
	EgoVenture.change_scene_to_file("res://scenes/man/man08.tscn")


func _on_Hotspot3_activate():
	Boombox.play_effect(preload("res://sounds/man/man_bath_cupb_op.ogg"))
	EgoVenture.target_view = "right"
	EgoVenture.change_scene_to_file("res://scenes/man/man23d_op1.tscn")


func _on_Hotspot4_activate():
	Boombox.play_effect(preload("res://sounds/man/man_bath_cupb_op.ogg"))
	EgoVenture.target_view = "right"
	EgoVenture.change_scene_to_file("res://scenes/man/man23d_op2.tscn")
