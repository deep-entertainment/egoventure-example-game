extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_box_cl.ogg"))
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaCore.change_scene("res://scenes/man/man11b_op.tscn")

