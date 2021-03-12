extends Node2D


func _ready():
	MdnaCore.check_cursor()
	Speedy.hidden = false
	Cursors.reset(Cursors.Type.MAP)


func _on_Hotspot_pressed():
	get_tree().quit()
