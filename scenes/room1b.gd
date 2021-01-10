extends Node2D


func _ready():
	Cursors.override(Cursors.Type.GO_BACKWARDS, preload("res://icon.png"), Vector2(32, 32))
	
	
func _exit_tree():
	Cursors.reset(Cursors.Type.GO_BACKWARDS)


func _on_right_pressed():
	MdnaCore.change_scene("res://scenes/room1l.tscn")


func _on_left_pressed():
	MdnaCore.change_scene("res://scenes/room1r.tscn")
