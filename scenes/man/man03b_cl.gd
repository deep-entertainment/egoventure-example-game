extends Node2D


func _ready():
	MdnaCore.check_cursor()
	(MdnaCore.state as GameState).eye_info_hs = true
	(MdnaCore.state as GameState).eye_info_hs2 = true
