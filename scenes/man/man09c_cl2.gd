extends Node2D

func _process(_delta):
	var state = EgoVenture.state
	if state.match_takeable:
		$match_takeable.hide()
	else:
		$match_takeable.show()


func _on_match_takeable_activate():
	Boombox.play_effect(preload("res://sounds/man/man_matches_up.ogg"))
	EgoVenture.change_scene_to_file("res://scenes/man/man09c_cl2_lift1.tscn")
