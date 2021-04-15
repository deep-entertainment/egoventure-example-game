extends Node2D


func _ready():
	(EgoVenture.state as GameState).man_folder_seen = 1
	Notepad.finished_step(3, 1)





func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_test_back.ogg"))
	EgoVenture.change_scene("res://scenes/man/man06c_op.tscn")
