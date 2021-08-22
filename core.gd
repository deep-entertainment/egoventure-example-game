# Carol Reed - Sins Of The Fathers (Godot Demo)
extends Node

func _ready():
	_initialization()
	EgoVenture.configure(preload("res://configuration.tres"))
	MainMenu.connect("new_game", self, "_on_new_game")
	Inventory.connect("triggered_inventory_item", self, "_on_triggered_inventory_item")
	Inventory.connect("released_inventory_item", self, "_on_released_inventory_item")
	EgoVenture.connect("game_loaded", self, "_on_load")
	
func _on_triggered_inventory_item(item1: InventoryItem, item2: InventoryItem):
	if (item1.title == "screwdriver" and item2.title == "file") or (item1.title == "file" and item2.title == "screwdriver"):
		Boombox.ignore_pause = true
		get_tree().paused = true
		Boombox.play_effect(preload("res://sounds/man/comb_screw_file.ogg"))
		yield(get_tree().create_timer(1), "timeout")
		Inventory.add_item(preload("res://inventory/screwdriver_mod.tres"))
		Inventory.release_item()
		get_tree().paused = false
		Boombox.ignore_pause = false
		Inventory.remove_item(preload("res://inventory/screwdriver.tres"))
		Inventory.remove_item(preload("res://inventory/file.tres"))
		(EgoVenture.state as GameState).screw_comb = 1
		Notepad.finished_step(4, 2)
		DetailView.show(preload("res://inventory/screwdriver_mod.tres"))

func _on_new_game():
	EgoVenture.change_scene("res://scenes/intro.tscn")

func _initialization():
	var state = GameState.new()
	EgoVenture.state = state
	
func _on_released_inventory_item(item: InventoryItem):
	print_debug("Released item %s" % item.title)
	
func _on_load():
	pass
