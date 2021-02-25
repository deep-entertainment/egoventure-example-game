extends Node2D


func _ready():
	MdnaInventory.disable()
	yield(get_tree().create_timer(10), "timeout")
	MdnaInventory.enable()
	(MdnaCore.state as GameState).eye_info_hs = true
	(MdnaCore.state as GameState).eye_info_hs2 = true
	MdnaCore.target_view = "right"
	MdnaCore.change_scene("res://scenes/man/man03.tscn")