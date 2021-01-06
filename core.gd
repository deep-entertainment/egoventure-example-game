# Carol Reed - Sins Of The Fathers (Godot Demo)
extends Node


func _ready():
	MdnaCore.state = GameState.new()
	MdnaCore.configure(preload("res://configuration.tres"))
	Parrot.subtitles = MdnaCore.in_game_configuration.subtitles
	Parrot.configure(MdnaCore.configuration.theme)
	MainMenu.connect("new_game", self, "_on_new_game")


func _on_new_game():
	MdnaCore.update_cache("res://scenes/room1f.tscn", true)
	yield(MdnaCore, "queue_complete")
	MdnaCore.change_scene("res://scenes/intro.tscn")
