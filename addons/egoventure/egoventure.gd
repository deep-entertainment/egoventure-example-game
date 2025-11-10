# First person point and click adventure framework for Godot
extends Node


# Emits when the game was loaded
signal game_loaded

# Emits when the queue of the scene cache has completed
signal queue_complete

# Emitted when a loaded game needs to change the target view but is
# already in the current scene
signal requested_view_change(to)

# Emitted when the waiting screen finished loading
signal waiting_completed


# The current state of the game
var state: BaseState

# Path of the current scene
var current_scene: String = ""

# Is the current scene a multi side room
var current_scene_is_multi_side: bool = false

# The current view of the four side room
var current_view: String = ""

# The target view for the next room
var target_view: String = ""

# Current location (subfolder in scenes folder)
var current_location: String = ""

# Wether the game has started. Should be set to true in the first interactive 
# scene
var game_started: bool = false

# The in game configuration (sound and subtitles)
var in_game_configuration: InGameConfiguration

# The game's configuration
var configuration: GameConfiguration

# Wether at least one savegame exists
var saves_exist: bool = false

# A timer that runs down while a waiting screen is shown
var wait_timer: Timer

# Whether the game currently accepts input
var interactive: bool = true: set = _set_interactive

# A cache of scenes for faster switching
var _scene_cache: SceneCache

# Helper variable if we're on a touch device
var is_touch: bool

# A texture for an empty image
var _empty_image_texture: ImageTexture = null

# Test run enabled
var _test_run_enabled: bool = false


# Load the ingame configuration
func _init():
	# Workaround for faulty feature detection as described in
	# https://github.com/godotengine/godot/issues/49113
	is_touch = OS.get_name() == "Android" || OS.get_name() == "iOS"
	process_mode = Node.PROCESS_MODE_ALWAYS
	var userdir = DirAccess.open("user://")
	userdir.list_dir_begin()
	var file = userdir.get_next()
	while file != "":
		if file.match("save_*.tres"):
			saves_exist = true
			break
		file = userdir.get_next()
	userdir.list_dir_end()
	if !state:
		state = GameState.new()
	# INFO: Cursors.configure is needed here to ensure that the Cursors are
	# defined when starting a scene directly from Godot editor.
	Cursors.configure(preload("res://configuration.tres"))


# Create the wait timer
func _ready():
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	add_child(wait_timer)
	Boombox.reset()
	WaitingScreen.connect("skipped", Callable(self, "wait_skipped"))
	# Only process TestRun in case it is a debug build
	# and not running on touch devices
	if !is_touch and OS.is_debug_build():
		TestRun.process_mode = Node.PROCESS_MODE_INHERIT
		_test_run_enabled = true
	else:
		TestRun.process_mode = Node.PROCESS_MODE_DISABLED
		_test_run_enabled = false


# Update the scene cache
#
# ** Parameters **
#
# - delta: The time since the last call to _process
func _process(_delta):
	if not wait_timer.is_stopped():
		WaitingScreen.set_progress(
			100.0 - wait_timer.get_time_left() / \
					configuration.cache_minimum_wait_seconds * 100
		)
	else:
		_scene_cache.update_progress()


# Configure the game from the game's core class
#
# ** Parameters **
#
# - p_configuration: The game configuration
func configure(p_configuration: GameConfiguration):
	configuration = p_configuration
	_load_in_game_configuration()
	TranslationServer.set_locale(self.in_game_configuration.locale)
	MainMenu.configure(configuration)
	MainMenu.connect("quit_game", self._on_quit_game)
	Notepad.configure(configuration)
	Inventory.configure(configuration)
	#Cursors.configure(configuration)
	_scene_cache = SceneCache.new(
		configuration.cache_scene_count, 
		configuration.cache_scene_path,
		configuration.cache_permanent,
		configuration.cache_maximum_size_megabyte
	)
	MenuGrab.set_top(configuration.inventory_size)
	_scene_cache.connect("queue_complete", self._on_queue_complete)
	Parrot.configure(
		configuration.design_theme,
		configuration.tools_dialog_stretch_ratio,
		"Speech"
	)
	Parrot.time_addendum_seconds=0.5
	_warm_up_cache()
	

# Save the continue state when going into background on mobile
func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT \
			and is_touch:
		save_continue()


# Switch the current scene to the new scene
#
# ** Arguments **
#
# - path: The absolute path to the new scene
# - load_game_mode: true when the scene of a savegame is loaded, default is false
func change_scene(path: String, load_game_mode: bool = false):
	if path == current_scene and !load_game_mode:
		# no change of scene required
		return
	
	print("Changing to %s" % path)
	RenderingServer.render_loop_enabled = false
	if path != current_scene:
		current_scene = path
		get_tree().change_scene_to_packed(_scene_cache.get_scene(path))
	else:
		get_tree().reload_current_scene()
	await get_tree().node_added
	RenderingServer.render_loop_enabled = true
	current_scene_is_multi_side = false
	for child in get_tree().current_scene.get_children():
		if child.scene_file_path in \
				["res://addons/egoventure/nodes/four_side_room.tscn",
				"res://addons/egoventure/nodes/eight_side_room.tscn"]:
			current_scene_is_multi_side = true
	# update cursor shape after scene change
	Speedy.keep_shape_once = false
	Speedy.keep_shape = false
	Speedy.check_shape()
	
	# update cache when scene is changed
	update_cache(path)


# Set whether dialog line skipping is enabled in parrot
#
# ** Arguments **
#
# - value: Whether skipping is enabled
func set_parrot_skip_enabled(value: bool):
	(state as BaseState).parrot_skip_enabled = value
	Parrot.skip_enabled = value


# Save the current state of the game
#
# ** Arguments **
#
# - slot: The save slot index
func save(slot: int):
	saves_exist = true
	_update_state()
	ResourceSaver.save(
		EgoVenture.state,
		"user://save_%d.tres" % slot, 
		ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)


# Save the "continue" slot
func save_continue():
	if game_started:
		_update_state()
		in_game_configuration.continue_state = EgoVenture.state.duplicate()
		save_in_game_configuration()


# Save the in game configuration
func save_in_game_configuration():
	ResourceSaver.save(
		in_game_configuration,
		"user://in_game_configuration.tres", 
		ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)


# Load a game from a savefile
# 
# ** Arguments **
#
# -slot: The save slot index to load
func load(slot: int):
	_load(ResourceLoader.load("user://save_%d.tres" % slot, "", ResourceLoader.CACHE_MODE_REPLACE))
	

# Load the game from the continue state
func load_continue():
	var state = in_game_configuration.continue_state
	_load(state)


# Set the audio levels based on the in game configuration
func set_audio_levels():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Speech"), 
		options_get_speech_level()
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		options_get_music_level()
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Effects"),
		options_get_effects_level()
	)


# Cache scenes for better loading performance
#
# ** Arguments **
#
# - scene: The scene path and filename. If empty, will be set to the
#   current scene
# - blocking: Wether to display a waiting screen while caching
func update_cache(scene: String = "", blocking = false) -> int:
	if scene == "":
		scene = _get_current_scene().filename
	if blocking:
		WaitingScreen.display()
		WaitingScreen.is_skippable = false
	return _scene_cache.update_cache(scene)


# Check if a continue state exists
func has_continue_state() -> bool:
	var continue_state = in_game_configuration.continue_state
	return continue_state != null


# Set the subtitle
#
# ** Arguments **
#
# - value: Enable or disable subtitles
func options_set_subtitles(value: bool):
	in_game_configuration.subtitles = value
	Parrot.subtitles = value
	save_in_game_configuration()


# Get subtitle
#
# *Returns* The current subtitle setting
func options_get_subtitles() -> bool:
	return in_game_configuration.subtitles


# Set the speech volume
#
# ** Arguments **
#
# - value: The new value
func options_set_speech_level(value: float):
	in_game_configuration.speech_db = value
	save_in_game_configuration()
	

# Return the current speech volume
#
# *Returns* The current value
func options_get_speech_level() -> float:
	return in_game_configuration.speech_db


# Set the music volume
#
# ** Arguments **
#
# - value: The new value
func options_set_music_level(value: float):
	in_game_configuration.music_db = value
	save_in_game_configuration()
	

# Return the current music volume
#
# *Returns* The current value
func options_get_music_level() -> float:
	return in_game_configuration.music_db


# Set the effects volume
#
# ** Arguments **
#
# - value: The new value
func options_set_effects_level(value: float):
	in_game_configuration.effects_db = value
	save_in_game_configuration()
	

# Return the current speech volume
#
# *Returns* The current value
func options_get_effects_level() -> float:
	return in_game_configuration.effects_db
	

# Set full screen according to game configuration
func set_full_screen():
	var window = get_window()
	if in_game_configuration.fullscreen:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED
		# Size of the game's viewport
		var game_size = Vector2i(
			ProjectSettings.get("display/window/size/viewport_width"),
			ProjectSettings.get("display/window/size/viewport_height")
		)
		# Get the usable screen rectangle (position and size)
		var screen_rect = DisplayServer.screen_get_usable_rect()
		# Determine the size of the window decoration
		var decor_size = window.get_size_with_decorations() - window.size
		# The window's target size is game size + window decorations
		var target_size: Vector2i = game_size + decor_size
		if target_size > screen_rect.size:
			# For the scale ratio include the window decoration
			var scale_ratio: float = min(float(screen_rect.size.x) / float(target_size.x),
								float(screen_rect.size.y) / float(target_size.y))
			window.size = Vector2i(game_size * scale_ratio * 0.95)
		
		window.position = screen_rect.position + \
				(screen_rect.size - window.size) / 2
		print(window.position)


# Reset the game to the default
func reset():
	# Reset State and inventory
	for item in Inventory.get_items():
		Inventory.remove_item(item)
	EgoVenture.current_location = ""
	EgoVenture.current_view = ""
	EgoVenture.target_view = ""
	EgoVenture.game_started = false
	Boombox.reset()


# Show a waiting screen for the given time
func wait_screen(time: float):
	WaitingScreen.display()
	wait_timer.start(time)
	await wait_timer.timeout
	WaitingScreen.hide()
	emit_signal("waiting_completed")


# Called when the waiting screen was skipped
func wait_skipped():
	wait_timer.stop()
	emit_signal("waiting_completed")


# Reset the continue state
func reset_continue_state():
	in_game_configuration.continue_state = null
	game_started = false
	save_in_game_configuration()


# Update the state with the current values
func _update_state():
	EgoVenture.state.current_scene = _get_current_scene().scene_file_path
	EgoVenture.state.target_view = EgoVenture.current_view
	EgoVenture.state.target_position = EgoVenture.current_location
	EgoVenture.state.inventory_items = Inventory.get_items()
	if (
		(Boombox.is_music_playing()
		or (Boombox.is_music_paused() and get_tree().paused))
		and Boombox.get_music()
	):
		EgoVenture.state.current_music = Boombox.get_music() #.resource_path
	else:
		EgoVenture.state.current_music = [] #""
	if (
		(Boombox.is_background_playing()
		or (Boombox.is_background_paused() and get_tree().paused))
		and Boombox.get_background()
	):
		EgoVenture.state.current_background = Boombox.get_background() #.resource_path
	else:
		EgoVenture.state.current_background = [] #""


# Load a saved state. Reset the game first.
# Afterwards load the saved state
# add the inventory items, switch to the saved
# scene and emit the game_loaded signal
#
# ** Arguments **
#
# - p_state: The state to load
func _load(p_state: BaseState):
	reset()
	EgoVenture.state = p_state.duplicate()
	EgoVenture.state.goals_fulfilled = []
	for goal_fulfilled in p_state.goals_fulfilled:
		EgoVenture.state.goals_fulfilled.append(goal_fulfilled.duplicate())
	EgoVenture.target_view = EgoVenture.state.target_view
	EgoVenture.current_location = EgoVenture.state.target_position
	
	self.set_parrot_skip_enabled(state.parrot_skip_enabled)
	
	for item in Inventory.get_items():
		Inventory.remove_item(item)
	for item in state.inventory_items:
		Inventory.add_item(item, true)
	
	for reset_type in Cursors.CURSOR_MAP:
		Cursors.reset(reset_type)

	for cursor_type in p_state.overridden_cursors:
		var _cursor = p_state.overridden_cursors[cursor_type]
		Cursors.override(cursor_type, _cursor.texture, _cursor.hotspot)
	
	game_started = true
	Inventory.enable()
	MainMenu.saveable = true
	MainMenu.resumeable = true
	Parrot.cancel()
	
	if _empty_image_texture == null:
		var empty_image: Image = Image.create(
			ProjectSettings.get("display/window/size/viewport_width"),
			ProjectSettings.get("display/window/size/viewport_height"),
			true,
			Image.FORMAT_RGBA8
		)
		empty_image.fill(Color.BLACK)
		_empty_image_texture = ImageTexture.create_from_image(empty_image)
	
	WaitingScreen.set_image(_empty_image_texture)
	
	var cached_items = update_cache(EgoVenture.state.current_scene, true)
	if cached_items > 0:
		await self.queue_complete
	
	change_scene(EgoVenture.state.current_scene, true)
	
	if EgoVenture.state.current_music.size() > 0:
		var music_list: Array = []
		for music in EgoVenture.state.current_music:
			music_list.append([
					load(music[0]),
					music[1],
					music[2]])
		Boombox.play_music_list(music_list)
		
	if EgoVenture.state.current_background.size() > 0:
		var background_list: Array = []
		for background in EgoVenture.state.current_background:
			background_list.append([
					load(background[0]),
					background[1],
					background[2]])
		Boombox.play_background_list(background_list)
		
	emit_signal("game_loaded")


# Load the in game configuration
func _load_in_game_configuration():
	var conf_path = DirAccess.open("user://")
	if conf_path.file_exists("in_game_configuration.tres"):
		in_game_configuration = ResourceLoader.load("user://in_game_configuration.tres", "", ResourceLoader.CACHE_MODE_REPLACE)
	else:
		in_game_configuration = InGameConfiguration.new()
	options_set_subtitles(in_game_configuration.subtitles)
	set_audio_levels()
	set_full_screen()


# Get the current scene
func _get_current_scene() -> Node:
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)


# Transport the queue complete signal
func _on_queue_complete():
	emit_signal("queue_complete")


# The player wants to quit the game. Save the continue state and quit
func _on_quit_game():
	EgoVenture.save_continue()
	get_tree().quit()


# Warm up the cache by caching the permanent scenes
func _warm_up_cache():
	for scene in configuration.cache_permanent:
		print_debug("Queueing load of permanent scene %s" % scene)
		_scene_cache.update_permanent_cache(scene)


# Sets whether the game is currently accepting input or not
#
# ** Arguments **
#
# - value: true: Game accepts input, false: Game does not accept input
func _set_interactive(value: bool):
	interactive = value
	if self.interactive:
		Speedy.hidden = false
		get_tree().paused = false
	else:
		Speedy.hidden = true
		get_tree().paused = true


# Pauses the game for a given duration
# Can be called from scripts with
# 'await EgoVenture.pause(<duration>, <hide_mouse>)'
#
# ** Arguments **
#
# - duration: pause duration in seconds
# - hide_mouse:
#     true (default): mouse cursor is hidden during pause
#     false: mouse cursor is visible during pause (if the cursor is visible when starting the pause)
func pause(duration: float = 1.0, hide_mouse:bool = true) -> void:
	var mouse_was_hidden = Speedy.hidden
	# Hide mouse based on parameter
	if hide_mouse:
		Speedy.hidden = true
	# Pause game in case it wasn't set to non-interactive before
	if interactive:
		get_tree().paused = true
	# Wait for duration in seconds
	await get_tree().create_timer(duration).timeout
	# Show mouse in case it was hidden and visible before the pause
	if hide_mouse and !mouse_was_hidden:
		Speedy.hidden = false
	# Resume game in case it wasn't set to non-interactive before
	if interactive:
		get_tree().paused = false


# Get the current updated EgoVenture state
func get_state() -> BaseState:
	_update_state()
	return state.duplicate()


# Return whether test run is enabled
func is_test_run_enabled() -> bool:
	return _test_run_enabled
