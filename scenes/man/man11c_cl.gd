extends Node2D


func _ready():
	pass


func _on_TriggerHotspot_item_used(item: InventoryItem):
	if item.title == "screwdriver":
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/man_screwdriver_fail.ogg"))
		yield(get_tree().create_timer(1.4), "timeout")
		Parrot.play(preload("res://dialogs/carol_large.tres"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		MdnaInventory.release_item()
	elif item.title == "screwdriver_mod":
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/man_screwdriver_used.ogg"))
		yield(get_tree().create_timer(1.4), "timeout")
		get_tree().paused = false
		Boombox.ignore_pause = false
		MdnaInventory.release_item()
		(MdnaCore.state as GameState).eye_on_door = true
		(MdnaCore.state as GameState).hand_on_door = true
		Notepad.finished_step(4, 3)
		MdnaCore.change_scene("res://scenes/man/man13.tscn")
	elif item.title == "matchkey":
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/man_upper_hall_key_fail.ogg"))
		yield(get_tree().create_timer(1), "timeout")
		MdnaInventory.release_item()
		get_tree().paused = false
		Boombox.ignore_pause = false

