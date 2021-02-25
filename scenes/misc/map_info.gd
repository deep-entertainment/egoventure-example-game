extends Node2D


func _ready():
	MdnaCore.game_started = true
	MdnaInventory.enable()
	(MdnaCore.state as GameState).map_bro_new = true
	Boombox.play_music(preload("res://music/blue.ogg"))
