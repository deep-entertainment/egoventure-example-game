extends Node2D

func _process(_delta):
	var state = MdnaCore.state
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
	if (MdnaCore.state as GameState).menu_info_seen == 1:
		MdnaCore.target_view = "front"
		MdnaCore.change_scene("res://scenes/man/man04.tscn")
	else:
		(MdnaCore.state as GameState).menu_info_seen = 1
		MdnaCore.change_scene("res://scenes/man/man04a_inf.tscn")
