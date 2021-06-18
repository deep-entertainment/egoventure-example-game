extends Node2D

func _ready():
	pass


func _on_Hotspot_activate():
	yield(get_tree().create_timer(0.2), "timeout")
	EgoVenture.target_view = "front"
	EgoVenture.change_scene("res://scenes/man/man21.tscn")
