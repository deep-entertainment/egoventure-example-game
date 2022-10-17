extends Node2D



func _on_Hotspot_activate() -> void:
	Inventory.add_item(preload("res://inventory/screwdriver_nongrabbable.tres"))
