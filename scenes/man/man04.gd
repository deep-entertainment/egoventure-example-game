


extends Node2D


func _ready():
	Boombox.play_background(preload("res://sounds/backgrounds/bg_birds_new2.ogg")) 
	Boombox.play_music(preload("res://music/guitar.ogg"))


func _on_Hotspot_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_outer_door_op.ogg"))
	Boombox.stop_background()
