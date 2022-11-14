extends Node2D


func _ready():
	pass

func _on_TriggerHotspot_item_used(item):
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	await get_tree().create_timer(0.4).timeout
	get_tree().paused = false
	Boombox.ignore_pause = false
	Inventory.remove_item(preload("res://inventory/matchkey.tres"))
	(EgoVenture.state as GameState).upper_door_hs = true
	(EgoVenture.state as GameState).hand_on_first_door = true
	(EgoVenture.state as GameState).use_info_will_be_seen = 0
	Notepad.finished_step(2, 2)
	EgoVenture.change_scene_to_file("res://scenes/man/man12.tscn")

