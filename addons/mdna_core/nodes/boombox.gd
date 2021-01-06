extends Node


# Play a new music file, if it isn't the current one.
func play_music(music: AudioStream):
	if music != $Music.stream or not $Music.playing:
		$Music.stream = music
		$Music.play()


# Pause playing music
func pause_music():
	$Music.stream_paused = true


# Resume playing music
func resume_music():
	$Music.stream_paused = false
	

# Stop the currently playing music
func stop_music():
	$Music.stop()
	

# Play a background effect
func play_background(background: AudioStream):
	if background != $Background.stream or not $Background.playing:
		$Background.stream = background
		$Background.play()


# Pause playing background effect
func pause_background():
	$Background.stream_paused = true
	
	
# Resume playing background effect
func resume_background():
	$Background.stream_paused = false


# Stop playing a background effect
func stop_background():
	$Background.stop()
	
	
# Play a sound effect
func play_effect(effect: AudioStream):
	if effect != $Effects.stream or not $Effects.playing:
		$Effects.stream = effect
		$Effects.play()


# Pause playing the sound effect
func pause_effect():
	$Effects.stream_paused = true


# Resume playing the sound effect
func resume_effect():
	$Effects.stream_paused = false


# Stop playing a sound a effect
func stop_effect():
	$Effects.stop
