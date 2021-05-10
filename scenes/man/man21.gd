extends Node2D

func _ready():
	check_hotspots()

func _process(_delta):
	check_hotspots()

func check_hotspots():
	var state = EgoVenture.state
	if state.temp_hand:
		$temp_hand.hide()
	else:
		$temp_hand.show()


func _on_temp_hand_activate():
	(EgoVenture.state as GameState).temp_hand = true
