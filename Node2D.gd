extends Node2D


func _ready():
	MdnaCore.check_cursor()
	$exit_hs.hide()


func _on_Hotspot2_pressed():
	DetailView.hide()
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	$exit_hs.show()
