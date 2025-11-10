extends Node2D

var volume: float 
var vol_delta = -1.0
var count = 0
var volume_background: int = 100

func _ready():
	_update_label()


func _process(_delta):
	
	### music cross fading effect
	if Boombox.is_music_playing() and \
			Boombox.get_volume_music(preload("res://music/piano.ogg")) != \
			AudioStreamPlaybackPolyphonic.INVALID_ID:
		count = count + 1
		if count > 100:
			count = 0
			volume = volume + vol_delta
			if volume < 1:
				vol_delta = 1
			elif volume > 99:
				vol_delta = -1
			Boombox.set_volume_music(volume, preload("res://music/piano.ogg"))
			Boombox.set_volume_music(100 - volume, preload("res://music/stina.ogg"))
	###
	
	### background volume "touchpad"
	if Boombox.is_background_playing():
		var pos = $Background/BB6.get_local_mouse_position()
		if (pos.x >= 0 and pos.y >= 0 and 
			pos.x <= $Background/BB6.size.x and 
			pos.y <= $Background/BB6.size.y and
			Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		):
			volume_background = pos.x * 100 / \
					$Background/BB6.size.x
			Boombox.set_volume_background(volume_background)
			_update_label()
	###


func _update_label() -> void:
	if Boombox.is_background_playing():
		$Background/Volume.text = "Volume: %d" % volume_background
	else:
		$Background/Volume.text = "Volume: -"


func _on_mb_1_pressed() -> void:
	Boombox.stop_music()


func _on_mb_2_pressed() -> void:
	Boombox.play_music(preload("res://music/guitar.ogg"))


func _on_mb_3_pressed() -> void:
	volume = 100
	Boombox.play_music_list([
		[preload("res://music/piano.ogg"), 0, 100],
		[preload("res://music/stina.ogg"), 0, 0]
	])


func _on_mb_4_pressed() -> void:
	Boombox.add_music(preload("res://music/blue.ogg"))


func _on_mb_5_pressed() -> void:
	Boombox.remove_music(preload("res://music/blue.ogg"))


func _on_bb_1_pressed() -> void:
	Boombox.stop_background()
	_update_label()


func _on_bb_2_pressed() -> void:
	Boombox.play_background(preload("res://sounds/backgrounds/bg_birds_new2.ogg"))
	_update_label()


func _on_bb_3_pressed() -> void:
	Boombox.add_background(preload("res://sounds/clock.ogg"))
	_update_label()


func _on_bb_4_pressed() -> void:
	if Boombox.is_background_playing():
		if volume_background > 0:
			if volume_background > 10:
				volume_background = volume_background - 10
			else:
				volume_background = 0
			Boombox.set_volume_background(volume_background)
			_update_label()


func _on_bb_5_pressed() -> void:
	if Boombox.is_background_playing():
		if volume_background < 100:
			if volume_background < 90:
				volume_background = volume_background + 10
			else:
				volume_background = 100
			Boombox.set_volume_background(volume_background)
			_update_label()


func _on_bb_7_pressed() -> void:
	Boombox.remove_background(preload("res://sounds/clock.ogg"))
	_update_label()
	

func _on_eb_1_pressed() -> void:
	Boombox.play_effect(preload("res://sounds/man/man_stairs.ogg"))


func _on_eb_2_pressed() -> void:
	Boombox.play_effect(preload("res://sounds/man/man_upper_hall_box_op.ogg"))


func _on_eb_3_pressed() -> void:
	Boombox.play_effect(preload("res://sounds/man/man_gate.ogg"))


func _on_eb_4_pressed() -> void:
	Boombox.play_effect(preload("res://sounds/misc/map_icon.ogg"))


func _on_eb_5_pressed() -> void:
	Boombox.play_effect(preload("res://sounds/cheers.ogg"))
