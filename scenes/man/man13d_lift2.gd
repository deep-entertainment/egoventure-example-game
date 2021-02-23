extends Node2D


func _ready():
	Cursors.override(Cursors.Type.MAP, preload("res://images/mouse/common.png"), Vector2(32, 32))
	Notepad.finished_step(6, 1)

