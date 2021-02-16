extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_cl.ogg"))
	MdnaCore.target_view = "right"
	MdnaCore.change_scene("res://scenes/man/man11.tscn")



func _on_Hotspot2_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_box_op.ogg"))
	yield(get_tree().create_timer(0.9), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaCore.change_scene("res://scenes/man/man11b_op_op.tscn")
