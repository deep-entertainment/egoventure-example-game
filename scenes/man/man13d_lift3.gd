extends Node2D


func _ready():
	Speedy.hidden = true
	yield(get_tree().create_timer(7), "timeout")
	get_tree().quit()
	
