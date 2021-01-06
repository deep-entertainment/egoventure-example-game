extends Node2D




func _on_Keys_pressed():	
	MdnaInventory.add_item(preload("res://inventory/keys.tres"))
	(MdnaCore.state as GameState).has_keys = true
	$Audio.stream = preload("res://sounds/keys.ogg")
	$Audio.play()
	$WithKeys.hide()
	yield(get_tree().create_timer(1), "timeout")
	MdnaCore.target_view = FourSideRoom.VIEW_FRONT
	MdnaCore.change_scene("res://scenes/room8.tscn")
