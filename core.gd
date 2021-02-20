# Carol Reed - Sins Of The Fathers (Godot Demo)
extends Node

func _ready():
	_initialization()
	MdnaCore.configure(preload("res://configuration.tres"))
	Parrot.subtitles = MdnaCore.options_get_subtitles()
	Parrot.configure(MdnaCore.configuration.theme)
	Parrot.time_addendum_seconds=0.5
	MainMenu.connect("new_game", self, "_on_new_game")
	MdnaInventory.connect("triggered_inventory_item", self, "_on_triggered_inventory_item")
	MdnaCore.connect("game_loaded", self, "_on_load")
	
func _on_triggered_inventory_item(item1: InventoryItem, item2: InventoryItem):
	if (item1.title == "screwdriver" and item2.title == "file") or (item1.title == "file" and item2.title == "screwdriver"):
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/comb_screw_file.ogg"))
		yield(get_tree().create_timer(1), "timeout")
		MdnaInventory.add_item(preload("res://inventory/screwdriver_mod.tres"))
		MdnaInventory.release_item()
		get_tree().paused = false
		Boombox.ignore_pause = false
		MdnaInventory.remove_item(preload("res://inventory/screwdriver.tres"))
		(MdnaCore.state as GameState).screw_comb = 1
		Notepad.finished_step(4, 2)
		DetailView.show(preload("res://inventory/screwdriver_mod.tres"))

func _on_new_game():
	_initialization()
	var items = MdnaCore.update_cache("res://scenes/room1f.tscn", true)
	if items > 0:
		yield(MdnaCore, "queue_complete")
	MdnaCore.change_scene("res://scenes/intro.tscn")

func _initialization():
	var state = GameState.new()
	MdnaCore.state = state
	

func _on_load():
	pass
