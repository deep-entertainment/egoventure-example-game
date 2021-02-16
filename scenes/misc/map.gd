extends Node2D


func _ready():
	Boombox.play_music(preload("res://music/blue.ogg"))
	Boombox.stop_background()
