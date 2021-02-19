extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_bath_cupb_cl.ogg"))
	MdnaCore.target_view = "left"
	MdnaCore.change_scene("res://scenes/man/man23.tscn")



func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
