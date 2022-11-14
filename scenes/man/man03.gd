extends Node2D

func _process(_delta):
	var state = EgoVenture.state
	if state.eye_info_hs:
		$eye_info_hs.hide()
	else:
		$eye_info_hs.show()
	if state.eye_info_hs2:
		$eye_info_hs2.hide()
	else:
		$eye_info_hs2.show()

func _ready():
	pass


func _on_Hotspot2_pressed():
	if (EgoVenture.state as GameState).menu_info_seen == 1:
		EgoVenture.target_view = "front"
		EgoVenture.change_scene_to_file("res://scenes/man/man04.tscn")
	else:
		(EgoVenture.state as GameState).menu_info_seen = 1
		EgoVenture.change_scene_to_file("res://scenes/man/man04a_inf.tscn")
