# The configuration of an MDNA game base don MDNA core
tool
class_name GameConfiguration
extends Resource


# The default theme for the menu controls
var theme: Theme

# The game's logo
var logo: Texture

# Hotspot cursors
var hotspot_cursors: Array

# Inventory configuration
var inventory_configuration: InventoryConfiguration

# The path to the hints csv file
var hints_file: String

# The menu background texture
var menu_background: Texture

# The music playing when the menu is opened
var menu_music: AudioStream

# A sound effect to play when the something is pressed
var menu_switch_effect: AudioStream

# The background texture for the save slots
var menu_saveslots_background: Texture

# The image for the "Previous page" button
var menu_saveslots_previous_image: Texture

# The image for the "Next page" button
var menu_saveslots_next_image: Texture

# The background of the options menu
var menu_options_background: Texture

# The sample to play when the speech slider is changed
var menu_options_speech_sample: AudioStream

# The sample to play when the effect slider is changed
var menu_options_effects_sample: AudioStream

# The texture in the notepad screen
var notepad_background: Texture

# The notepad goals label rect
var notepad_goals_rect: Rect2

# The notepad hints label rect
var notepad_hints_rect: Rect2

# The flashing map image
var map_image: Texture

# The sound to play when flashing the map
var map_sound: AudioStream

# The path where the scenes are stored
var scene_path: String = "res://scenes"

# Number of scenes to precache before and after the current scene
var scene_cache_count: int = 3

# Default image scaling
var scene_default_image_scaling: float = 1.0

# A list of scenes (as path to the scene files) that are always cached
var advanced_permanent_cache: PoolStringArray = []


# Build the property list
func _get_property_list():
	var properties = []
	properties.append({
		name = "Common",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "theme",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Theme"
	})
	properties.append({
		name = "logo",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "hotspot_cursors",
		type = TYPE_ARRAY,
		hint = 24,
		hint_string = "17/17:HotspotCursor"
	})
	properties.append({
		name = "inventory_configuration",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "InventoryConfiguration"
	})
	properties.append({
		name = "hints_file",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_FILE,
		hint_string = "*.txt"
	})
	properties.append({
		name = "Menu",
		type = TYPE_NIL,
		hint_string = "menu_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_music",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_switch_effect",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "Saveslots",
		type = TYPE_NIL,
		hint_string = "menu_saveslots",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_saveslots_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_previous_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_next_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "Notepad",
		type = TYPE_NIL,
		hint_string = "notepad",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "notepad_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "notepad_goals_rect",
		type = TYPE_RECT2
	})
	properties.append({
		name = "notepad_hints_rect",
		type = TYPE_RECT2
	})
	properties.append({
		name = "Options",
		type = TYPE_NIL,
		hint_string = "menu_options",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_options_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_options_speech_sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_options_effects_sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "map_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "map_sound",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "scene_path",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_DIR
	})
	properties.append({
		name = "scene_cache_count",
		type = TYPE_INT
	})
	properties.append({
		name = "scene_default_image_scaling",
		type = TYPE_REAL
	})
	properties.append({
		name = "Advanced",
		type = TYPE_NIL,
		hint_string = "advanced",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "advanced_permanent_cache",
		type = TYPE_STRING_ARRAY,
	})
	return properties
