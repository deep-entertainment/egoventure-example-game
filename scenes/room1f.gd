extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MdnaCore.game_started = true
	MdnaInventory.enable()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_right_pressed():
	MdnaCore.change_scene("res://scenes/room1r.tscn")


func _on_left_pressed():
	MdnaCore.change_scene("res://scenes/room1l.tscn")




func _on_Hotspot_pressed():
	MdnaInventory.add_item(preload("res://inventory/keys.tres"))
	MdnaInventory.add_item(preload("res://inventory/keys.tres"))
