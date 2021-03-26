extends Node2D


func _ready():
	EgoVenture.check_cursor()


func _on_Hotspot_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_cl.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.target_view = "back"
	EgoVenture.change_scene("res://scenes/man/man06.tscn")


func _on_Hotspot2_activate():
	Boombox.play_effect(preload("res://sounds/man/man_test_up.ogg"))
	EgoVenture.change_scene("res://scenes/man/man06c_lift1.tscn")
