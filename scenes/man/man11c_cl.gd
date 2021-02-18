extends Node2D

func _ready():
	pass

func _on_man_hs_for_screwdriver_item_used(item):
	if (MdnaCore.state as GameState).screw_comb == 1:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/man_screwdriver_used.ogg"))
		yield(get_tree().create_timer(1.4), "timeout")
		get_tree().paused = false
		Boombox.ignore_pause = false
		MdnaInventory.release_item()
		(MdnaCore.state as GameState).eye_on_door = true
		(MdnaCore.state as GameState).hand_on_door = true
		MdnaCore.change_scene("res://scenes/man/man13.tscn")
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/man_screwdriver_fail.ogg"))
		yield(get_tree().create_timer(1.4), "timeout")
		Parrot.play(preload("res://dialogs/carol_large.tres"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		MdnaInventory.release_item()
	
