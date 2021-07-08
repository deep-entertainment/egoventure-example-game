extends Node2D

func _ready():
	pass

func _on_Hotspot_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.target_view = "front"
	EgoVenture.change_scene("res://scenes/man/man17.tscn")
