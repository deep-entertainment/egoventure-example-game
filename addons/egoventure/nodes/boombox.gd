# Boombox - a singleton audio player framework
extends Node


# The volume to fade to if the channel should be off
const VOLUME_MIN = -80

# The volume to fade to if hte channel should be on
const VOLUME_MAX = 0

# Volume that gets returned when audio file is not played
const INVALID_VOLUME = -1


# Emited when a sound effect completed playing
signal effect_finished


# Let Boombox ignore game pausing. So all sound will continue
# playing when a game is paused
var ignore_pause: bool: set = _set_ignore_pause


# The fader used for fading music
var _music_fader: Tween

# The fader used for fading background sounds
var _background_fader: Tween

# The queue of music to fade
var _music_queue: Array = []

# The queue of backgrounds to fade
var _background_queue: Array = []

# A flag that tells the music is stopping. Cancel events that are waiting
# for the tween to finish
var _music_is_stopping: bool = false

# enum for Music or Background fader 
enum {FADER_MUSIC, FADER_BACKGROUND}

# array of effects playing
var _effect_playing: Array[int] = []

# inner class for audio stream information
class Audio:
	var stream: AudioStream
	var position: float
	var volume: float
	
	func _init(stream, position = 0.0, volume = 100.0):
		self.stream = stream
		self.position = position
		self.volume = volume

# arrays of music and background playing
var _music_playing: Dictionary = {}
var _background_playing: Dictionary = {}

# The active music player
@onready var active_music: AudioStreamPlayer = $Music1

# The active background player
@onready var active_background: AudioStreamPlayer = $Background1


# Create the tweens
func _ready():
	_music_fader = create_tween()
	_music_fader.stop()
	_background_fader = create_tween()
	_background_fader.stop()


func _process(_delta):
	# Check the queues and start the fades
	if _music_queue.size() > 0 and not _music_fader.is_running():
		play_music_list(_music_queue.pop_front())
	
	if _background_queue.size() > 0 and not _background_fader.is_running():
		play_background_list(_music_queue.pop_front())
	
	# Check whether effects are still playing
	if _effect_playing.size() > 0:
		var _effect_stopped: Array[int] = []
		for effect_id in _effect_playing:
			if !$Effects.get_stream_playback().is_stream_playing(effect_id):
				_effect_stopped.append(effect_id)
		for effect_id in _effect_stopped:
			_effect_playing.erase(effect_id)
		if _effect_playing.size() == 0:
			emit_signal("effect_finished")


# Reset the settings. Stop all music, sounds and backgrounds
# Used when starting a new game
func reset():
	$Music1.stop()
	$Music2.stop()
	if active_music != $Music1:
		active_music = $Music1
	$Background1.stop()
	$Background2.stop()
	if active_background != $Background1:
		active_background = $Background1
	#_music_fader.reset_all()
	#_background_fader.reset_all()
	$Effects.stop()
	_reset_background_volume()
	_reset_music_volume()


func _get_audio_id(audio: AudioStream, list: Dictionary) -> int:
	for id in list:
		if list[id].stream == audio:
			return id
	return AudioStreamPlaybackPolyphonic.INVALID_ID


# Play a new music file, if it isn't the current one.
#
# ** Parameters**
#
# - music: An audiostream of the music to play
func play_music(music: AudioStream, from_position: float = 0.0, volume: float = 100.0):
	play_music_list([[music, from_position, volume]])


func play_music_list(audio_list: Array):
	var audio_list_typed: Array[Audio]
	if _music_fader.is_running():
		_music_queue.append(audio_list)
	else:
		for item in audio_list:
			audio_list_typed.append(Audio.new(item[0], item[1], item[2]))
		if not active_music.playing:
			active_music.play()
			_music_playing.clear()
			for audio in audio_list_typed:
				var music_id = active_music.get_stream_playback().play_stream(
						audio.stream,
						audio.position,
						linear_to_db(audio.volume / 100)
				)
				if music_id == AudioStreamPlaybackPolyphonic.INVALID_ID:
					print("Music could not be played. Maximum number of audio has been reached. ")
				else:
					_music_playing[music_id] = audio
		else:
			var keep_music: bool = true
			for audio in audio_list_typed:
				var music_found: bool = false
				for music in _music_playing.values():
					if !music_found and audio.stream == music.stream:
						music_found = true
				if music_found == false:
					keep_music = false
			if keep_music:
				return
			var fade_to = $Music2
			if active_music == $Music2:
				fade_to = $Music1
			_music_playing.clear()
			_music_fader = _fade(
				active_music, 
				fade_to, 
				audio_list_typed,
				EgoVenture.configuration.tools_music_fader_seconds,
				FADER_MUSIC
			)


func add_music(music: AudioStream, from_position: float = 0.0, volume = 100.0):
	if !active_music.playing:
		# no music is playing, call play_music instead
		play_music(music, from_position, volume)
	
	var id = _get_audio_id(music, _music_playing)
	# only add music if it isn't already playing
	if id == AudioStreamPlaybackPolyphonic.INVALID_ID:
		id = active_music.get_stream_playback().play_stream(
				music,
				from_position,
				linear_to_db(volume / 100)
		)
		if id == AudioStreamPlaybackPolyphonic.INVALID_ID:
			print("Music could not be played. Maximum number of audio has been reached. ")
		else:
			_music_playing[id] = Audio.new(music, from_position, volume)


func remove_music(music: AudioStream):
	var id = _get_audio_id(music, _music_playing)
	if id != AudioStreamPlaybackPolyphonic.INVALID_ID:
		active_music.get_stream_playback().stop_stream(id)
		_music_playing.erase(id)


func set_volume_music(volume: float, music: AudioStream = null):
	if music:
		# set volume for one music sound
		var id = _get_audio_id(music, _music_playing)
		if id != AudioStreamPlaybackPolyphonic.INVALID_ID:
			active_music.get_stream_playback().set_stream_volume(id, linear_to_db(volume / 100))
			_music_playing[id].volume = volume
	else:
		# set volume for all music sounds
		for id in _music_playing:
			active_music.get_stream_playback().set_stream_volume(id, linear_to_db(volume / 100))
			_music_playing[id].volume = volume


func get_volume_music(music: AudioStream):
	if music:
		var id = _get_audio_id(music, _music_playing)
		if id != AudioStreamPlaybackPolyphonic.INVALID_ID:
			return _music_playing[id].volume
	return INVALID_VOLUME


# Pause playing music
func pause_music():
	active_music.stream_paused = true


# Resume playing music
func resume_music():
	active_music.stream_paused = false
	

# Stop the currently playing music
func stop_music():
	_music_is_stopping = true
	if _music_fader:
		_music_fader.stop()
	_music_queue = []
	_music_playing.clear()
	$Music1.stop()
	$Music2.stop()
	active_music = $Music1
	_reset_music_volume()
	

# Get the current music
func get_music() -> Array:
	var music_list: Array = []
	for item in _music_playing.values():
		music_list.append([
			item.stream.resource_path,
			item.position,
			item.volume
		])
	return music_list


# Get whether boombox is currently playing music
func is_music_playing() -> bool:
	return active_music.playing


# Get whether boombox's active music is currently paused
func is_music_paused() -> bool:
	return active_music.stream_paused


# Play a background effect
#
# ** Parameters **
#
# - background: An audiostream of the background noise to play
func play_background(background: AudioStream, from_position: float = 0.0, volume = 100.0):
	play_background_list([[background, from_position, volume]])


func play_background_list(audio_list: Array):
	var audio_list_typed: Array[Audio]
	if _background_fader.is_running():
		_background_queue.append(audio_list)
	else:
		for item in audio_list:
			audio_list_typed.append(Audio.new(item[0], item[1], item[2]))
		if not active_background.playing:
			active_background.play()
			_background_playing.clear()
			for audio in audio_list_typed:
				var id = active_background.get_stream_playback().play_stream(
						audio.stream,
						audio.position,
						linear_to_db(audio.volume / 100)
				)
				if id == AudioStreamPlaybackPolyphonic.INVALID_ID:
					print("Background could not be played. Maximum number of audio has been reached. ")
				else:
					_background_playing[id] = audio
		else:
			var keep_background: bool = true
			for audio in audio_list_typed:
				var background_found: bool = false
				for background in _background_playing.values():
					if !background_found and audio.stream == background.stream:
						background_found = true
				if background_found == false:
					keep_background = false
			if keep_background:
				return
			var fade_to = $Background2
			if active_background == $Background2:
				fade_to = $Background1
			_background_playing.clear()
			_background_fader = _fade(
				active_background, 
				fade_to, 
				audio_list_typed,
				EgoVenture.configuration.tools_background_fader_seconds,
				FADER_BACKGROUND
			)


func add_background(background: AudioStream, from_position: float = 0.0, volume = 100.0):
	if !active_background.playing:
		# no background is playing, call play_background instead
		play_background(background, from_position, volume)
	
	var id = _get_audio_id(background, _background_playing)
	# only add background if it isn't already playing
	if id == AudioStreamPlaybackPolyphonic.INVALID_ID:
		id = active_background.get_stream_playback().play_stream(
				background,
				from_position,
				linear_to_db(volume / 100)
		)
		if id == AudioStreamPlaybackPolyphonic.INVALID_ID:
			print("Background could not be played. Maximum number of audio has been reached. ")
		else:
			_background_playing[id] = Audio.new(background, from_position, volume)


func remove_background(background: AudioStream):
	var id = _get_audio_id(background, _background_playing)
	if id != AudioStreamPlaybackPolyphonic.INVALID_ID:
		active_background.get_stream_playback().stop_stream(id)
		_background_playing.erase(id)


func set_volume_background(volume: float, background: AudioStream = null):
	if background:
		# set volume for one background sound
		var id = _get_audio_id(background, _background_playing)
		if id != AudioStreamPlaybackPolyphonic.INVALID_ID:
			active_background.get_stream_playback(). \
					set_stream_volume(id, linear_to_db(volume / 100))
			_background_playing[id].volume = volume
	else:
		# set volume for all background sounds
		for id in _background_playing:
			active_background.get_stream_playback(). \
					set_stream_volume(id, linear_to_db(volume / 100))
			_background_playing[id].volume = volume


func get_volume_background(background: AudioStream):
	if background:
		var id = _get_audio_id(background, _background_playing)
		if id != AudioStreamPlaybackPolyphonic.INVALID_ID:
			return _background_playing[id].volume
	return INVALID_VOLUME


# Pause playing background effect
func pause_background():
	active_background.stream_paused = true
	
	
# Resume playing background effect
func resume_background():
	active_background.stream_paused = false


# Stop playing a background effect
func stop_background():
	if _background_fader:
		_background_fader.stop()
	_background_queue = []
	_background_playing.clear()
	$Background1.stop()
	$Background2.stop()
	active_background = $Background1
	_reset_background_volume()


# Get the current background
func get_background() -> Array:
	var background_list: Array = []
	for item in _background_playing.values():
		background_list.append([
			item.stream.resource_path,
			item.position,
			item.volume
		])
	return background_list


# Get wether boombox is currently playing background
func is_background_playing() -> bool:
	return active_background.playing


# Get whether boombox's active BACKGROUND is currently paused
func is_background_paused() -> bool:
	return active_background.stream_paused


# Play a sound effect
#
# ** Parameters **
#
# - effect: An audiostream of the sound effect to play
#   make sure it's set to "loop = false" in the import settings
func play_effect(effect: AudioStream, from_position: float = 0.0, volume_percent: float = 100.0):
	var effect_id: int
	
	# start Effects AudioStream
	if !$Effects.playing:
		$Effects.play()
	
	# Play the effect
	effect_id = $Effects.get_stream_playback().play_stream(
			effect,
			from_position,
			linear_to_db(volume_percent / 100)
	)
	if effect_id == AudioStreamPlaybackPolyphonic.INVALID_ID:
		print("Effect could not be played. Maximum number of audio has been reached. ")
	else:
		_effect_playing.append(effect_id)


# Pause playing the sound effect
func pause_effect():
	$Effects.stream_paused = true


# Resume playing the sound effect
func resume_effect():
	$Effects.stream_paused = false


# Stop playing a sound a effect
func stop_effect():
	$Effects.stop()


# React to ignore_pause
func _set_ignore_pause(value: bool):
	ignore_pause = value
	if ignore_pause:
		process_mode = Node.PROCESS_MODE_ALWAYS
		if _background_fader:
			_background_fader.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		if _music_fader:
			_music_fader.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	else:
		process_mode = Node.PROCESS_MODE_PAUSABLE
		if _background_fader:
			_background_fader.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
		if _music_fader:
			_music_fader.set_pause_mode(Tween.TWEEN_PAUSE_STOP)


# Fade a channel
#
# #### Parameters
#
# - fade_from: Fade from this channel
# - fade_to: Fade to this channel
# - stream: Stream to play on the fade_to channel
# - time: Time to take to fade
# - type: music or background fader
#
# #### Returns
#
# - Tween
func _fade(
	fade_from: Node, 
	fade_to: Node, 
	audio_list: Array[Audio],
	time: float, 
	type: int
) -> Tween:
	
	fade_to.play()
	for audio in audio_list:
		var id = fade_to.get_stream_playback().play_stream(
				audio.stream,
				audio.position,
				linear_to_db(audio.volume / 100)
		)
		if id == AudioStreamPlaybackPolyphonic.INVALID_ID:
			if type == FADER_MUSIC:
				print("Music could not be played. Maximum number of audio has been reached. ")
			else:
				print("Background could not be played. Maximum number of audio has been reached. ")
		else:
			if type == FADER_MUSIC:
				_music_playing[id] = audio
			elif type == FADER_BACKGROUND:
				_background_playing[id] = audio
	
	var fader = create_tween()
	if type == FADER_MUSIC:
		fader.connect(
			"finished", self._handle_music_tween_completed
		)
	elif type == FADER_BACKGROUND:
		fader.connect(
			"finished", self._handle_background_tween_completed
		)
	
	fader.tween_property(
		fade_from,
		"volume_db",
		VOLUME_MIN,
		time
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	fader.tween_property(
		fade_to,
		"volume_db",
		VOLUME_MAX,
		time
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	fader.play()
	
	return fader


# Reset the music volume
func _reset_music_volume():	
	$Music1.volume_db = VOLUME_MAX
	$Music2.volume_db = VOLUME_MIN


# Reset the background volume
func _reset_background_volume():
	$Background1.volume_db = VOLUME_MAX
	$Background2.volume_db = VOLUME_MIN


# Handle a completed music tween
func _handle_music_tween_completed():
	var fade_to = $Music2
	if active_music == $Music2:
		fade_to = $Music1
	
	active_music.stop()
	active_music = fade_to


# Handle a completed background tween
func _handle_background_tween_completed():
	var fade_to = $Background2
	if active_background == $Background2:
		fade_to = $Background1
	
	active_background.stop()
	active_background = fade_to
