extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hotspot2_pressed():
	Notepad.finished_step(1, 1)


func _on_Hotspot3_pressed():
	Notepad.finished_step(2, 1)


func _on_Hotspot4_pressed():
	Notepad.finished_step(3, 1)

func _on_Hotspot5_pressed():
	Notepad.finished_step(3, 2)


func _on_Hotspot6_pressed():
	Notepad.finished_step(4, 1)


func _on_Hotspot7_pressed():
	Notepad.finished_step(5, 1)


func _on_Hotspot8_pressed():
	Notepad.finished_step(5, 2)


func _on_Hotspot9_pressed():
	Notepad.finished_step(5, 3)


func _on_Hotspot10_pressed():
	Notepad.finished_step(5, 4)


func _on_Hotspot11_pressed():
	Notepad.finished_step(5, 5)
