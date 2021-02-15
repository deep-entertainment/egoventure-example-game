extends Node2D


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
