extends Node2D

func _ready():
	if (MdnaCore.state as GameState).has_keys:
		$Keys.hide()
		$ToKeys.hide()
