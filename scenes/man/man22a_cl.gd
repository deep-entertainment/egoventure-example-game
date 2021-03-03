extends Node2D

func _ready():
	check_hotspots()
	MdnaCore.check_cursor()
	
func _process(_delta):
	check_hotspots()
	
func check_hotspots():
	var state = MdnaCore.state
	if state.man_rag:
		$man_rag.hide()
	else:
		$man_rag.show()


func _on_man_rag_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_file_up.ogg"))


func _on_Hotspot_pressed():
	MdnaCore.change_scene("res://scenes/man/man22a_xcl.tscn")
