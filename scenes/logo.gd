


extends Control

func _ready():
	Speedy.hidden = true
	MdnaInventory.disable()
	MainMenu.disabled = true
	get_tree().paused = true
	yield(get_tree().create_timer(5), "timeout")
	get_tree().paused = false
	MainMenu.disabled = false
	Speedy.hidden = false
	MdnaCore.change_scene("res://scenes/menu.tscn")
