extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Cursors.override(Cursors.Type.GO_FORWARD_X, preload("res://images/mouse/common.png"), Vector2(32, 32))
	
	
func _exit_tree():
	Cursors.reset(Cursors.Type.GO_FORWARD_X)
