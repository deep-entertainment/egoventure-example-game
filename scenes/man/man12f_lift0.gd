extends Node2D


func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_back.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man12f_op.tscn")



func _on_Hotspot_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_op.ogg"))
	await get_tree().create_timer(0.6).timeout
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene_to_file("res://scenes/man/man12f_lift1.tscn")
