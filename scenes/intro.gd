extends Control

func _ready():
	Speedy.hidden = true
	EgoVenture.game_started = true
	MainMenu.disabled = true
	Inventory.disable()
	MainMenu.saveable = true
	$cred2.hide()
	Boombox.play_music(preload("res://music/tunnel.ogg"))
	await get_tree().create_timer(7).timeout
	$cred2.show()
	await get_tree().create_timer(7).timeout
	Speedy.hidden = false
	EgoVenture.change_scene("res://scenes/misc/map_info.tscn")


func _on_cred1_pressed():
	$cred2.show()


func _on_cred2_pressed():
	Speedy.hidden = false
	EgoVenture.change_scene("res://scenes/misc/map_info.tscn")
