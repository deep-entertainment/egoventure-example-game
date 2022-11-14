extends Node2D


func _ready():
	$bur_j.hide()
	$bur_k.hide()
	$bur_b.hide()
	$bur_7a.hide()
	$bur_7b.hide()
	$bur_6.hide()
	var state = EgoVenture.state
	if state.man_hand_on_bur:
		$man_hand_on_bur.show()
	else:
		$man_hand_on_bur.hide()

func _on_Hotspot3_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
	$bur_k.show()
	(EgoVenture.state as GameState).bor_opened = 0
	await get_tree().create_timer(0.4).timeout
	$bur_k.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false


func _on_Hotspot4_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
	$bur_7a.show()
	(EgoVenture.state as GameState).bor_opened = 0
	await get_tree().create_timer(0.4).timeout
	$bur_7a.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false


func _on_Hotspot5_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
	$bur_7b.show()
	(EgoVenture.state as GameState).bor_opened = 0
	await get_tree().create_timer(0.4).timeout
	$bur_7b.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false


func _on_Hotspot6_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
	$bur_b.show()
	(EgoVenture.state as GameState).bor_opened = 1
	await get_tree().create_timer(0.4).timeout
	$bur_b.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false


func _on_Hotspot2_pressed():
	if (EgoVenture.state as GameState).bor_opened == 1:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
		$bur_j.show()
		(EgoVenture.state as GameState).bor_opened = 2
		await get_tree().create_timer(0.4).timeout
		$bur_j.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
		$bur_j.show()
		(EgoVenture.state as GameState).bor_opened = 0
		await get_tree().create_timer(0.4).timeout
		$bur_j.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false


func _on_Hotspot7_pressed():
	if (EgoVenture.state as GameState).bor_opened == 2:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
		$bur_6.show()
		(EgoVenture.state as GameState).bor_opened = 3
		await get_tree().create_timer(0.4).timeout
		$bur_6.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
		$bur_6.show()
		(EgoVenture.state as GameState).bor_opened = 0
		await get_tree().create_timer(0.4).timeout
		$bur_6.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false


func _on_Hotspot8_pressed():
	if (EgoVenture.state as GameState).bor_opened == 3 && (EgoVenture.state as GameState).man_folder_seen == 1:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
		$bur_1.show()
		(EgoVenture.state as GameState).bor_opened = 3
		await get_tree().create_timer(0.4).timeout
		$bur_1.hide()
		(EgoVenture.state as GameState).man_hand_on_bur = true
		Boombox.play_effect(preload("res://sounds/man/man_1776_op.ogg"))
		get_tree().paused = false
		Boombox.ignore_pause = false
		EgoVenture.change_scene_to_file("res://scenes/man/man12f_op.tscn")
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/wood_click.ogg"))
		$bur_1.show()
		(EgoVenture.state as GameState).bor_opened = 0
		await get_tree().create_timer(0.4).timeout
		$bur_1.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
