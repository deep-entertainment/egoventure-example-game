# Carol Reed - Sins Of The Fathers (Godot Demo)
extends Node


func _ready():
	MdnaCore.state = GameState.new()
	MdnaCore.configure(preload("res://configuration.tres"))
	Parrot.subtitles = MdnaCore.in_game_configuration.subtitles
	Parrot.configure(MdnaCore.configuration.theme)
	MdnaInventory.connect("triggered_hotspot", self, "_on_triggered_hotspot")
	MainMenu.connect("new_game", self, "_on_new_game")


func _on_triggered_hotspot(
	hotspot: TriggerHotspot,
	item: InventoryItem
):
	print_debug(
		"Triggered hotspot %s with item %s" % [hotspot.name, item.title]
	)
	match hotspot.name:
		"Bush": 
			if item.title == "Keys":
				Parrot.play(preload("res://dialogs/keys.tres"))


func _on_new_game():
	MdnaCore.update_cache("res://scenes/room1f.tscn", true)
	yield(MdnaCore, "queue_complete")
	MdnaCore.change_scene("res://scenes/intro.tscn")
