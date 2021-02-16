
extends Node2D

func _process(_delta):
	var state = MdnaCore.state
	if state.hs_on_ins:
		$hs_on_ins.hide()
	else:
		$hs_on_ins.show()


func _ready():
	pass
