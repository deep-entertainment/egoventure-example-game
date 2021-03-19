extends Control

func _ready():
	Speedy.hidden = true
	EgoVenture.game_started = true
	Inventory.disable()
	MainMenu.saveable = true
	$cred2.hide()
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_music(preload("res://music/tunnel.ogg"))
	yield(get_tree().create_timer(7), "timeout")
	$cred2.show()
	yield(get_tree().create_timer(7), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	Speedy.hidden = false
	EgoVenture.change_scene("res://scenes/misc/map_info.tscn")
