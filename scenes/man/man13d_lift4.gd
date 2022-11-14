extends Node2D


func _ready():
	await get_tree().create_timer(7).timeout
	EgoVenture.change_scene_to_file("res://scenes/misc/license.tscn")
