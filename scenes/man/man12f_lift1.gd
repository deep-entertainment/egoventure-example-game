extends Node2D


func _ready():
	var state = EgoVenture.state
	if state.screwdr_hs:
		$screwdr_hs.hide()
	else:
		$screwdr_hs.show()



func _on_Hotspot_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_cl.ogg"))
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene_to_file("res://scenes/man/man12f_lift0.tscn")
