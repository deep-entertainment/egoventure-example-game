# A hotspot supporting precaching of scenes and showing a loading
# screen and playing a tune while doing so
tool
class_name MapHotspot, "res://addons/mdna_core/images/map_hotspot.svg"
extends Hotspot


# The loading image to show while the scenes for the new location are
# cached
export(Texture) var loading_image

# The music that should be played while loading
export(AudioStream) var location_music

# The new location (subdirectory of the scene files)
export(String) var location = ""


# Connect the pressed signal
func _init():
	connect("pressed", self, "_on_pressed")


# Update cache blocking for the target scene, then jump there
func _on_pressed():
	release_focus()
	if MdnaInventory.selected_item == null:
		accept_event()
		Boombox.play_music(location_music)
		MdnaCore.target_view = target_view
		MdnaCore.current_location = location
		WaitingScreen.set_image(loading_image)
		var caches = MdnaCore.update_cache(target_scene, true)
		if caches > 0:
			yield(MdnaCore, "queue_complete")
		MdnaCore.change_scene(target_scene)
