extends Node2D


func _on_TriggerHotspot_item_used(item: InventoryItem):
	if item.title == "Keys":
		Parrot.play(preload("res://dialogs/keys.tres"))
