extends Node2D

func _ready():
	$man_stairs.hide()
	Boombox.play_music(preload("res://music/piano.ogg"))
	Cursors.override(Cursors.Type.CUSTOM1, preload("res://images/mouse/hand.png"), Vector2(46, 32))


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_outer_door_op.ogg"))


func _on_Hotspot4_pressed():
	if (MdnaCore.state as GameState).use_info_will_be_seen == 1:
		Speedy.hidden = true
		Boombox.ignore_pause = true
		get_tree().paused = true
		$man_stairs.show()
		Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().paused = false
		Boombox.ignore_pause = false
		MdnaCore.target_view = "front"
		Speedy.hidden = false
		MdnaCore.change_scene("res://scenes/man/man11a_inf.tscn")	
	else:
		Speedy.hidden = true
		Boombox.ignore_pause = true
		get_tree().paused = true
		$man_stairs.show()
		Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().paused = false
		Boombox.ignore_pause = false
		Speedy.hidden = false
		MdnaCore.check_cursor()
		MdnaCore.target_view = "front"
		MdnaCore.change_scene("res://scenes/man/man11.tscn")


