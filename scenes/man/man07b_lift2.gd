extends Node2D


func _ready():
	MdnaCore.check_cursor()
	Cursors.override(Cursors.Type.CUSTOM1, preload("res://images/mouse/curv_left.png"), Vector2(32, 32))


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_skarbrade_back.ogg"))
	MdnaCore.target_view = "right"
	MdnaCore.change_scene("res://scenes/man/man07.tscn")


func _on_Hotspot2_pressed():
	MdnaCore.change_scene("res://scenes/man/man07b_lift1.tscn")
