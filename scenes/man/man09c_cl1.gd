extends Node2D


func _ready():
	pass


func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_book_up.ogg"))
	MdnaCore.change_scene("res://scenes/man/man09c_lift1.tscn")

