extends Node2D


func _ready():
	Boombox.play_music(preload("res://music/blue.ogg"))
	Boombox.stop_background()
	var state = MdnaCore.state
	if state.map_kevo:
		$map_kevo.show()
	else:
		$map_kevo.hide()
	if state.map_kevo_new:
		$map_kevo_new.show()
	else:
		$map_kevo_new.hide()



func _on_map_kevo_pressed():
	(MdnaCore.state as GameState).map_kevo_new = false
