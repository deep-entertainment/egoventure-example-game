extends Node2D


#func _ready():
#	check_hotspots()

	

#func _process(_delta):
#	check_hotspots()
#
#
#func check_hotspots():
#	var state = EgoVenture.state
#	if state.man_hand_on_insex:
#		$man_hand_on_insex.show()
#	else:
#		$man_hand_on_insex.hide()


func _on_TriggerHotspot_item_used(item):
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_insex_used.ogg"))
	await get_tree().create_timer(1.6).timeout
	Inventory.remove_item(preload("res://inventory/insex.tres"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	(EgoVenture.state as GameState).man_hand_on_insex = true
	EgoVenture.change_scene_to_file("res://scenes/man/man06c_op.tscn")



func _on_man_hand_on_insex_activate():
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_op.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man06c_op.tscn")

