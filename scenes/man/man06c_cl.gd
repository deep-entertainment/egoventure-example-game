extends Node2D

func _process(_delta):
	var state = MdnaCore.state
	if state.man_hand_on_insex:
		$man_hand_on_insex.show()
	else:
		$man_hand_on_insex.hide()


func _ready():
	pass


func _on_TriggerHotspot_item_used(item):
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_insex_used.ogg"))
	yield(get_tree().create_timer(1.6), "timeout")
	MdnaInventory.remove_item(preload("res://inventory/insex.tres"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	(MdnaCore.state as GameState).man_hand_on_insex = true
	MdnaCore.change_scene("res://scenes/man/man06c_op.tscn")


func _on_man_hand_on_insex_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_op.ogg"))
	MdnaCore.change_scene("res://scenes/man/man06c_op.tscn")
