extends Node2D
var cigbox_opened


func _ready():
	$cigbox_a.hide()
	$cigbox_m.hide()
	$cigbox_b.hide()
	$cigbox_e.hide()
	$cigbox_r.hide()
	$cigbox_t.hide()
	$cigbox_z.hide()


func _on_Hotspot_pressed():
	if cigbox_opened == 1:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
		$cigbox_a.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$cigbox_a.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
		cigbox_opened = 2
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
		$cigbox_a.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$cigbox_a.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
		cigbox_opened = 0


func _on_Hotspot2_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
	$cigbox_m.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$cigbox_m.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false
	cigbox_opened = 0


func _on_Hotspot3_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
	$cigbox_b.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$cigbox_b.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false
	cigbox_opened = 0


func _on_Hotspot4_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
	$cigbox_t.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$cigbox_t.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false
	cigbox_opened = 0


func _on_Hotspot5_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
	$cigbox_r.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$cigbox_r.hide()
	get_tree().paused = false
	Boombox.ignore_pause = false
	cigbox_opened = 1


func _on_Hotspot6_pressed():
	if cigbox_opened == 2:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
		$cigbox_z.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$cigbox_z.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
		cigbox_opened = 3
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
		$cigbox_z.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$cigbox_z.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
		cigbox_opened = 0


func _on_Hotspot7_pressed():
	if cigbox_opened == 3:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
		$cigbox_e.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$cigbox_e.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
		Boombox.play_effect(preload("res://sounds/man/man_cigar_op.ogg"))
		MdnaCore.change_scene("res://scenes/man/man13d_lift2.tscn")
	else:
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/cigbox_click.ogg"))
		$cigbox_e.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$cigbox_e.hide()
		get_tree().paused = false
		Boombox.ignore_pause = false
		cigbox_opened = 0
