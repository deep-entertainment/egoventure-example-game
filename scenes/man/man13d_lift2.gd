extends Node2D


func _ready():
	EgoVenture.reset_continue_state()
	Cursors.override(Cursors.Type.MAP, preload("res://images/mouse/common.png"), Vector2(32, 32))
	Boombox.play_music(preload("res://music/blue.ogg"))
	Notepad.finished_step(6, 1)


