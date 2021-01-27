extends Node2D

func _ready():
	var state = MdnaCore.state
	if state.has_keys:
		$Keys.hide()
		$ToKeys.hide()
