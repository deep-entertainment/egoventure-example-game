extends Node2D


func _ready():
	MdnaCore.check_cursor()
	var state = MdnaCore.state
	if state.map_bro_new:
		$map_bro_new.show()
	else:
		$map_bro_new.hide()
	if state.map_kevo:
		$map_kevo.show()
	else:
		$map_kevo.hide()
	if state.map_kevo_new:
		$map_kevo_new.show()
	else:
		$map_kevo_new.hide()
	Boombox.play_music(preload("res://music/blue.ogg"))
	Boombox.stop_background()




