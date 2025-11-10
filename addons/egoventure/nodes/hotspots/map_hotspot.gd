@tool
# A hotspot supporting precaching of scenes and showing a loading
# screen and playing a tune while doing so
@icon("res://addons/egoventure/images/map_hotspot.svg")
class_name MapHotspot
extends Hotspot


# The loading image to show while the scenes for the new location are
# cached
@export var loading_image: Texture2D

# The music that should be played while loading
@export var location_music: AudioStream

# The new location (subdirectory of the scene files)
@export var location: String = ""

# Set the boolean value of this variable in the state to true
@export var state_variable: String = ""


# Connect the pressed signal
func _init():
	cursor_type = Cursors.Type.MAP
	super()


# Update cache blocking for the target scene, then jump there
func _on_pressed():
	# Add node information to test script when recording
	if EgoVenture.is_test_run_enabled() and TestRun.is_recording():
		TestRun.test_script.set_node_info(self.get_class(), self.get_path())
	# Process pressed event
	release_focus()
	if Inventory.selected_item == null:
		Speedy.hidden = true
		accept_event()
		if effect:
			Boombox.play_effect(effect)
		if state_variable:
			EgoVenture.state.set(state_variable, false)
		Boombox.play_music(location_music)
		EgoVenture.target_view = target_view
		EgoVenture.current_location = location
		WaitingScreen.set_image(loading_image)
		var start = Time.get_ticks_msec()
		var caches = EgoVenture.update_cache(target_scene, true)
		if caches > 0:
			await EgoVenture.queue_complete
		var end = Time.get_ticks_msec()
		if ((end - start) / 1000) < \
				EgoVenture.configuration.cache_minimum_wait_seconds:
			EgoVenture.wait_screen(
				ceil(
					EgoVenture.configuration.cache_minimum_wait_seconds -\
					((end - start) / 1000)
				)
			)
			WaitingScreen.is_skippable = true
			await EgoVenture.waiting_completed
		Speedy.hidden = false
		EgoVenture.change_scene(target_scene)
