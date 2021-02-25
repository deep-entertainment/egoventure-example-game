extends Node2D

func _process(_delta):
	var state = MdnaCore.state
	if state.match_takeable:
		$match_takeable.hide()
	else:
		$match_takeable.show()


func _ready():
	MdnaCore.check_cursor()


func _on_match_takeable_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_matches_up.ogg"))
	MdnaCore.change_scene("res://scenes/man/man09c_cl2_lift1.tscn")
