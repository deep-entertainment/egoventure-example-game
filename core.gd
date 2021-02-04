# Carol Reed - Sins Of The Fathers (Godot Demo)
extends Node


func _ready():
	MdnaCore.configure(preload("res://configuration.tres"))
	Parrot.subtitles = MdnaCore.options_get_subtitles()
	Parrot.configure(MdnaCore.configuration.theme)
	Parrot.time_addendum_seconds=0.5
	MainMenu.connect("new_game", self, "_on_new_game")
	MdnaInventory.connect("triggered_inventory_item", self, "_on_triggered_inventory_item")
	MdnaCore.connect("game_loaded", self, "_on_load")
	
func _on_triggered_inventory_item(item1: InventoryItem, item2: InventoryItem):
	pass

func _on_new_game():
	var state = GameState.new()
	MdnaCore.state = state
	var items = MdnaCore.update_cache("res://scenes/room1f.tscn", true)
	if items > 0:
		yield(MdnaCore, "queue_complete")
	MdnaCore.change_scene("res://scenes/intro.tscn")

func _on_load():
	pass
