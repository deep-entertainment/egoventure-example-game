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
