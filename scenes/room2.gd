extends Node2D

func _ready():
	Parrot.connect("finished_dialog", self, "_on_finished_dialog")
	_update_hotspots()

func _update_hotspots():
	pass

func _on_finished_dialog(dialog_id: String):
	
	_update_hotspots()
