extends Node2D

func _process(_delta):
	var state = MdnaCore.state
	if state.man_rag:
		$man_rag.hide()
	else:
		$man_rag.show()

func _ready():
	MdnaCore.check_cursor()


func _on_man_rag_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_file_up.ogg"))
