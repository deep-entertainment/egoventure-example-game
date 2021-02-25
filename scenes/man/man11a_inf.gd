extends Node2D


func _ready():
	MdnaCore.check_cursor()

func _on_TriggerHotspot_item_used(item):
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaInventory.remove_item(preload("res://inventory/matchkey.tres"))
	(MdnaCore.state as GameState).upper_door_hs = true
	(MdnaCore.state as GameState).hand_on_first_door = true
	(MdnaCore.state as GameState).use_info_will_be_seen = 0
	Notepad.finished_step(2, 2)
	MdnaCore.change_scene("res://scenes/man/man12.tscn")
