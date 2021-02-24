extends Node2D


func _ready():
	Speedy.hidden = true
	MdnaInventory.disable()
	yield(get_tree().create_timer(10), "timeout")
	MdnaCore.change_scene("res://scenes/man/man11.tscn")
	(MdnaCore.state as GameState).use_info_will_be_seen = 0
	MdnaInventory.enable()
	Speedy.hidden = false
