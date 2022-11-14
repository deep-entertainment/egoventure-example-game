extends Node2D

func _ready():
	Parrot.connect("finished_dialog",Callable(self,"_on_finished_dialog"))
	if (EgoVenture.state as GameState).bro_spoken_to != 1:
		Speedy.hidden = true
		Parrot.play(preload("res://dialogs/bro1_q0.tres"))
		await Parrot.finished_dialog
		Speedy.hidden = false
		(EgoVenture.state as GameState).bro_spoken_to = 1
	
func _process(_delta):
	_update_hotspots()

func _update_hotspots():
	var state = EgoVenture.state
	if state.bro_q1_hs:
		$bro_q1_hs.show()
		if not state.bro_q2_hs:
			$bro_q1_hs.asked = false
	else:
		$bro_q1_hs.hide()
	if state.bro_q2_hs:
		$bro_q2_hs.show()
		$bro_q1_hs.asked = true
	else:
		$bro_q2_hs.hide()
	if state.bro_q3_hs:
		$bro_q3_hs.show()
		$bro_q2_hs.asked = true
	else:
		$bro_q3_hs.hide()

func _on_finished_dialog(dialog_id: String):
	if dialog_id == "bro1_q0":
		(EgoVenture.state as GameState).bro_q1_hs = true
	if dialog_id == "bro1_q1":
		(EgoVenture.state as GameState).bro_q2_hs = true
	if dialog_id == "bro1_q2" && (EgoVenture.state as GameState).bro_q3_hs != true:
		MapNotification.notify()
		(EgoVenture.state as GameState).map_kevo_new = true
		(EgoVenture.state as GameState).map_kevo = true
		(EgoVenture.state as GameState).bro_q3_hs = true
		Notepad.finished_step(1, 1)
	_update_hotspots()


func _on_bro_q3_hs_pressed():
	EgoVenture.change_scene_to_file("res://scenes/misc/map.tscn")
