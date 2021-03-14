extends Node2D

func _process(_delta):
	Cursors.override(Cursors.Type.CORNER_LEFT, preload("res://images/mouse/common.png"), Vector2(32, 32))
	var state = EgoVenture.state
	if state.upper_door_hs:
		$upper_door_hs.hide()
	else:
		$upper_door_hs.show()
	if state.eye_on_door:
		$eye_on_door.hide()
	else:
		$eye_on_door.show()
	if state.hand_on_door:
		$hand_on_door.show()
	else:
		$hand_on_door.hide()
	if state.hand_on_first_door:
		$hand_on_first_door.show()
	else:
		$hand_on_first_door.hide()


func _ready():
	$man_stairs.hide()
	Cursors.override(Cursors.Type.CUSTOM1, preload("res://images/mouse/right_corner_down.png"), Vector2(32, 32))


func _on_Hotspot4_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene("res://scenes/man/man11b_op.tscn")


func _on_TriggerHotspot_item_used(item):
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	Inventory.remove_item(preload("res://inventory/matchkey.tres"))
	(EgoVenture.state as GameState).upper_door_hs = true
	(EgoVenture.state as GameState).hand_on_first_door = true
	Notepad.finished_step(2, 2)
	EgoVenture.change_scene("res://scenes/man/man12.tscn")
	
	

func _exit_tree():
	Cursors.reset(Cursors.Type.CORNER_LEFT)



func _on_Hotspot2_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_boxroom_op.ogg"))
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene("res://scenes/man/man11b_op.tscn")


func _on_Hotspot3_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_upper_boiler_room_op.ogg"))
	EgoVenture.target_view = "left"
	EgoVenture.change_scene("res://scenes/man/man11d_op.tscn")


func _on_Hotspot_pressed():
	Speedy.hidden = true
	Boombox.ignore_pause = true
	get_tree().paused = true
	$man_stairs.show()
	Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.target_view = "back"
	Speedy.hidden = false
	EgoVenture.change_scene("res://scenes/man/man05.tscn")
