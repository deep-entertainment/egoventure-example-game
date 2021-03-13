extends Node2D


func _ready():
	yield(get_tree().create_timer(10), "timeout")
	(EgoVenture.state as GameState).eye_info_hs = true
	(EgoVenture.state as GameState).eye_info_hs2 = true
	EgoVenture.target_view = "right"
	EgoVenture.change_scene("res://scenes/man/man03.tscn")
