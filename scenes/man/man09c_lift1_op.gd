extends Node2D



func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_green_book_cl.ogg"))
	MdnaCore.change_scene("res://scenes/man/man09c_lift1.tscn")
