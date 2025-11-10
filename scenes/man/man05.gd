extends Node2D

func _ready():
	$man_stairs.hide()
	Boombox.play_music(preload("res://music/piano.ogg"))





func _on_Hotspot4_activate():
	if (EgoVenture.state as GameState).use_info_will_be_seen == 1:
		Speedy.hidden = true
		get_tree().paused = true
		$man_stairs.show()
		Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))
		await get_tree().create_timer(1.5).timeout
		get_tree().paused = false
		EgoVenture.target_view = "front"
		Speedy.hidden = false
		EgoVenture.change_scene("res://scenes/man/man11a_inf.tscn")	
	else:
		Speedy.hidden = true
		get_tree().paused = true
		$man_stairs.show()
		Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))
		await get_tree().create_timer(1.5).timeout
		get_tree().paused = false
		Speedy.hidden = false
		EgoVenture.target_view = "front"
		EgoVenture.change_scene("res://scenes/man/man11.tscn")
