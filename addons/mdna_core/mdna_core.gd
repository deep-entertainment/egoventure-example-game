# Core features for MDNA games
extends Node


# Emits when the game was loaded
signal game_loaded

# Emits when the queue of the scene cache has completed
signal queue_complete


# A regex to search for the scene index in a scene filename.
# e.g.: home04b.tscn has the index 4, castle12detail1.tscn has the index 12.
const SCENE_REGEX = "^[a-z]+(?<index>\\d+)\\D?.*$"


# The current state of the game
var state: BaseState

# The target view for the next room
var target_view: String = ""

# Wether the game has started. Should be set to true in the first interactive 
# scene
var game_started: bool = false

# The in game configuration (sound and subtitles)
var in_game_configuration: InGameConfiguration

# The game's configuration
var configuration: GameConfiguration


# A cache of scenes for faster switching
var _scene_cache: SceneCache


# Load the ingame configuration
func _init():
	_load_in_game_configuration()
	

# Update the scene cache
#
# ** Parameters **
#
# - delta: The time since the last call to _process
func _process(_delta):
	_scene_cache.update_progress()


# Configure the game from the game's core class
#
# ** Parameters **
#
# - p_configuration: The game configuration
func configure(p_configuration: GameConfiguration):
	configuration = p_configuration
	MainMenu.configure(configuration)
	Notepad.configure(configuration)
	MdnaInventory.configure(configuration.inventory_configuration)
	MdnaInventory.connect("notepad_pressed", self, "_on_notepad_pressed")
	Cursors.configure(configuration)
	MapNotification.configure(configuration)
	_scene_cache = SceneCache.new(
		configuration.scene_cache_count, 
		configuration.scene_path,
		SCENE_REGEX
	)
	_scene_cache.connect("queue_complete", self, "_on_queue_complete")


# Switch the current scene to the new scene
#
# ** Arguments **
#
# - path: The absolute path to the new scene
func change_scene(path: String):
	get_tree().change_scene_to(_scene_cache.get_scene(path))
	

# Save the current state of the game
#
# ** Arguments **
#
# - slot: The save slot index
func save(slot: int):
	var screenshot = get_viewport().get_texture().get_data()
	screenshot.flip_y()
	screenshot.save_png("user://save_%d.png" % slot)
	
	state.current_scene = _get_current_scene().filename
	state.inventory_items = MdnaInventory.get_items()
	ResourceSaver.save("user://save_%d.tres" % slot, state)


# Save the "resume" slot
func save_resume():
	state.current_scene = _get_current_scene().filename
	state.inventory_items = MdnaInventory.get_items()
	in_game_configuration.resume_state = state.duplicate(true)
	save_in_game_configuration()


# Load a game from a savefile
# 
# ** Arguments **
#
# -slot: The save slot index to load
func load(slot: int):
	_load(ResourceLoader.load("user://save_%d.tres" % slot))
	

# Load the game from the resume state
func load_resume():
	_load(in_game_configuration.resume_state)
	

# Save the in game configuration
func save_in_game_configuration():
	ResourceSaver.save(
		"user://in_game_configuration.tres", 
		in_game_configuration
	)


# Set the audio levels based on the in game configuration
func set_audio_levels():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Speech"), 
		in_game_configuration.speech_db
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		in_game_configuration.music_db
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Effects"),
		in_game_configuration.effects_db
	)
	

# Cache scenes for better loading performance
#
# ** Arguments **
#
# - scene: The scene path and filename. If empty, will be set to the
#   current scene
# - blocking: Wether to display a waiting screen while caching
func update_cache(scene: String = "", blocking = false):
	if scene == "":
		scene = _get_current_scene().filename
	if blocking:
		WaitingScreen.show()
	_scene_cache.update_cache(scene)


# the previously saved state, add the inventory items, switch to the saved
# scene and emit the game_loaded signal
#
# ** Arguments **
#
# - p_state: The state to load
func _load(p_state: BaseState):
	state = p_state.duplicate(true)
	for item in state.inventory_items:
		MdnaInventory.add_item(item)
	update_cache(state.current_scene, true)
	yield(_scene_cache, "queue_complete")
	change_scene(state.current_scene)
	save_resume()
	emit_signal("game_loaded")


# Load the in game configuration
func _load_in_game_configuration():
	var conf_path = Directory.new()
	conf_path.open("user://")
	if conf_path.file_exists("in_game_configuration.tres"):
		in_game_configuration = load("user://in_game_configuration.tres")
	else:
		in_game_configuration = InGameConfiguration.new()
	set_audio_levels()


# Get the current scene
func _get_current_scene() -> Node:
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)


func _on_queue_complete():
	emit_signal("queue_complete")


# Show the notepad
func _on_notepad_pressed():
	Notepad.show()
