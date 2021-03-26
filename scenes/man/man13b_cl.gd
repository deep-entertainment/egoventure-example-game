extends Node2D


func _ready():
	EgoVenture.check_cursor()



func _on_Hotspot2_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_inner_room_cabinet_op.ogg"))
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene("res://scenes/man/man13b_op.tscn")
