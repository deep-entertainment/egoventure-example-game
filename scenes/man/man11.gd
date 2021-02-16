extends Node2D

func _process(_delta):
	var state = MdnaCore.state
	if state.upper_door_hs:
		$upper_door_hs.hide()
	else:
		$upper_door_hs.show()


func _ready():
	$man_stairs.hide()
	Cursors.override(Cursors.Type.CUSTOM1, preload("res://images/mouse/right_corner_down.png"), Vector2(32, 32))


func _on_Hotspot_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	$man_stairs.show()
	Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaCore.target_view = "back"
	MdnaCore.change_scene("res://scenes/man/man05.tscn")


func _on_Hotspot3_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_upper_boiler_room_op.ogg"))
	MdnaCore.target_view = "left"
	MdnaCore.change_scene("res://scenes/man/man11d_op.tscn")


func _on_Hotspot4_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaCore.change_scene("res://scenes/man/man11b_op.tscn")


func _on_TriggerHotspot_item_used(item):
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaInventory.remove_item(preload("res://inventory/matchkey.tres"))
	(MdnaCore.state as GameState).upper_door_hs = true
	MdnaCore.change_scene("res://scenes/man/man12.tscn")

