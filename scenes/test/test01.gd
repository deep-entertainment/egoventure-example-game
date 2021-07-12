extends Node2D


func _ready():
	EgoVenture.current_location = "test"




func _on_TriggerHotspot_item_used(item):
	EgoVenture.target_view = "front"	
	EgoVenture.change_scene("res://scenes/test/test02.tscn")
