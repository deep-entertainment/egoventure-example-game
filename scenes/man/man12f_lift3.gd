extends Node2D


func _ready():
	EgoVenture.check_cursor()
	var state = EgoVenture.state
	if state.screwdr_hs:
		$screwdr_hs.hide()
	else:
		$screwdr_hs.show()
