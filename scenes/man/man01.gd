

extends Node2D

func _process(_delta):
	var state = MdnaCore.state
	if state.space_info:
		$space_info.hide()
	else:
		$space_info.show()

func _ready():
	Boombox.play_background(preload("res://sounds/backgrounds/bg_birds_new2.ogg")) 
	yield(get_tree().create_timer(13), "timeout")
	MdnaInventory.enable()
	Speedy.hidden = false
	(MdnaCore.state as GameState).space_info = true

func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_gate.ogg"))
