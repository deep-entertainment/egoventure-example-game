extends Node2D


func _ready():
	MdnaCore.check_cursor()
	var state = MdnaCore.state
	if state.screwdr_hs:
		$screwdr_hs.hide()
	else:
		$screwdr_hs.show()
