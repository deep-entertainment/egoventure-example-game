extends Node2D

func _ready():
	check_hotspots()
	
func _process(_delta):
	check_hotspots()
	
func check_hotspots():
	var state = EgoVenture.state
	if state.man_rag:
		$man_rag.hide()
	else:
		$man_rag.show()


func _on_man_rag_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_file_up.ogg"))


func _on_Hotspot_pressed():
	EgoVenture.change_scene("res://scenes/man/man22a_xcl.tscn")
