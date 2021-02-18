extends Node2D

func _ready():
	Parrot.connect("finished_dialog", self, "_on_finished_dialog")
	Speedy.hidden = true
	Parrot.play(preload("res://dialogs/bro1_q0.tres"))
	yield(Parrot, "finished_dialog")
	Speedy.hidden = false
	_update_hotspots()

func _update_hotspots():
	var state = MdnaCore.state
	if state.bro_q1_hs:
		$bro_q1_hs.show()
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
		(MdnaCore.state as GameState).bro_q1_hs = true
	if dialog_id == "bro1_q1":
		(MdnaCore.state as GameState).bro_q2_hs = true
	if dialog_id == "bro1_q2" && (MdnaCore.state as GameState).bro_q3_hs != true:
		MapNotification.notify()
		(MdnaCore.state as GameState).map_kevo_new = true
		(MdnaCore.state as GameState).map_kevo = true
		(MdnaCore.state as GameState).bro_q3_hs = true
	_update_hotspots()


func _on_bro_q3_hs_pressed():
	MdnaCore.change_scene("res://scenes/misc/map.tscn")
