extends Node2D


func _ready():
	pass


func _on_Hotspot_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_cl.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaCore.target_view = "back"
	MdnaCore.change_scene("res://scenes/man/man06.tscn")


func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_test_up.ogg"))
	MdnaCore.change_scene("res://scenes/man/man06c_lift1.tscn")
