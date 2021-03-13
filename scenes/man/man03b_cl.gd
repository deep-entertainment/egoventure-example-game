extends Node2D


func _ready():
	EgoVenture.check_cursor()
	(EgoVenture.state as GameState).eye_info_hs = true
	(EgoVenture.state as GameState).eye_info_hs2 = true
