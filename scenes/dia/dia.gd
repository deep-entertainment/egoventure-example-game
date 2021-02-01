extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Parrot.connect("finished_dialog", self, "_on_finished_dialog")
	$DialogHotspot2.hide()
	
func _process(_delta):
	var state = MdnaCore.state
	if state.DialogHotspot2:
		$DialogHotspot2.show()
	else:
		$DialogHotspot2.hide()
	if state.DialogHotspot3:
		$DialogHotspot3.show()
	else:
		$DialogHotspot3.hide()
	
func _on_finished_dialog(dialog_id: String):
	if dialog_id == "bro1_01" && (MdnaCore.state as GameState).bro1_q2 != 1:
		MapNotification.notify()
		(MdnaCore.state as GameState).DialogHotspot2 = true
		(MdnaCore.state as GameState).bro1_q2 = 1
	if dialog_id == "bro1_02":
		MapNotification.notify()
		(MdnaCore.state as GameState).DialogHotspot3 = true
		MdnaCore.change_scene("res://scenes/room1l.tscn")
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
