extends Node2D


func _ready():
	Cursors.override(Cursors.Type.CUSTOM1, preload("res://images/mouse/curv_right.png"), Vector2(32, 32))



func _on_Hotspot2_activate():
	EgoVenture.change_scene_to_file("res://scenes/man/man07b_lift2.tscn")


func _on_Hotspot_activate():
	Boombox.play_effect(preload("res://sounds/man/man_skarbrade_back.ogg"))
	Cursors.reset(Cursors.Type.CUSTOM1)
	EgoVenture.target_view = "right"
	EgoVenture.change_scene_to_file("res://scenes/man/man07.tscn")

