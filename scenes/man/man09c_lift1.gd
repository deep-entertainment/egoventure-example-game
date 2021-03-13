extends Node2D

var man_diary_open

func _ready():
	EgoVenture.check_cursor()
	$diary_pink.hide()
	$diary_yel.hide()
	$diary_blue.hide()
	$diary_red.hide()
	$diary_green.hide()
	$diary_black.hide()
	$diary_orange.hide()
	$diary_white.hide()
	$diary_purple.hide()


func _on_Hotspot_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_pink.show()
	yield(get_tree().create_timer(0.8), "timeout")
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	$diary_pink.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 0
	


func _on_Hotspot2_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_yel.show()
	yield(get_tree().create_timer(0.8), "timeout")
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	$diary_yel.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 0


func _on_Hotspot3_pressed():
	if man_diary_open == 1:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
		$diary_blue.show()
		yield(get_tree().create_timer(0.8), "timeout")
		$diary_blue.hide()
		Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		man_diary_open = 2
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
		$diary_blue.show()
		yield(get_tree().create_timer(0.8), "timeout")
		$diary_blue.hide()
		Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		man_diary_open = 0


func _on_Hotspot4_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_red.show()
	yield(get_tree().create_timer(0.8), "timeout")
	$diary_red.hide()
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 0


func _on_Hotspot5_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_green.show()
	yield(get_tree().create_timer(0.8), "timeout")
	$diary_green.hide()
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 1


func _on_Hotspot6_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_black.show()
	yield(get_tree().create_timer(0.8), "timeout")
	$diary_black.hide()
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 0


func _on_Hotspot7_pressed():
	if man_diary_open == 2 && (EgoVenture.state as GameState).tapestry_seen == 1:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
		$diary_orange.show()
		yield(get_tree().create_timer(0.8), "timeout")
		$diary_orange.hide()
		Boombox.play_effect(preload("res://sounds/man/man_green_book_open.ogg"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		Notepad.finished_step(5, 1)
		EgoVenture.change_scene("res://scenes/man/man09c_lift1_op.tscn")
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
		$diary_orange.show()
		yield(get_tree().create_timer(0.8), "timeout")
		$diary_orange.hide()
		Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		man_diary_open = 0



func _on_Hotspot8_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_white.show()
	yield(get_tree().create_timer(0.8), "timeout")
	$diary_white.hide()
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 0



func _on_Hotspot9_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/beep.ogg"))
	$diary_purple.show()
	yield(get_tree().create_timer(0.8), "timeout")
	$diary_purple.hide()
	Boombox.play_effect(preload("res://sounds/man/beep2.ogg"))
	get_tree().paused = false
	Boombox.ignore_pause = false
	man_diary_open = 0


func _on_Hotspot10_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_book_back.ogg"))
	EgoVenture.change_scene("res://scenes/man/man09c_cl1.tscn")

