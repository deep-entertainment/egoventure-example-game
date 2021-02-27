extends Node2D


func _ready():
	MdnaCore.check_cursor()
	(MdnaCore.state as GameState).space_info = true


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_gate.ogg"))




