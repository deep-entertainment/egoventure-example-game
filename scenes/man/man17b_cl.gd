extends Node2D


func _ready():
	EgoVenture.check_cursor()
	Cursors.override(Cursors.Type.LOOK, preload("res://images/mouse/common.png"), Vector2(32, 32))


func _exit_tree():
	Cursors.reset(Cursors.Type.LOOK)
