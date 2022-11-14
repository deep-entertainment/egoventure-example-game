

extends Node2D

func _process(_delta):
	var state = EgoVenture.state
	if state.space_info:
		$space_info.hide()
	else:
		$space_info.show()

func _ready():
	Boombox.play_background(preload("res://sounds/backgrounds/bg_birds_new2.ogg")) 
	await get_tree().create_timer(13).timeout
	Inventory.enable()
	Speedy.hidden = false
	(EgoVenture.state as GameState).space_info = true




func _on_Hotspot3_pressed() -> void:
	DetailView.show_with_item(preload("res://inventory/file.tres"))
