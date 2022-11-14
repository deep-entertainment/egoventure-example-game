extends Node2D


func _on_Hotspot2_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_box_op.ogg"))
	await get_tree().create_timer(0.9).timeout
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene_to_file("res://scenes/man/man11b_op_op.tscn")


func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_cl.ogg"))
	EgoVenture.target_view = "right"
	EgoVenture.change_scene_to_file("res://scenes/man/man11.tscn")
