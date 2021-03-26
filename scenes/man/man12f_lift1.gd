extends Node2D


func _ready():
	EgoVenture.check_cursor()
	var state = EgoVenture.state
	if state.screwdr_hs:
		$screwdr_hs.hide()
	else:
		$screwdr_hs.show()



func _on_Hotspot_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_cl.ogg"))
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene("res://scenes/man/man12f_lift0.tscn")
