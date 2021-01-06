# A trigger hotspot definition resource
tool
class_name TriggerHotspot
extends Resource

# The name of the hotspot
var name: String

# The name of the scene where this hotspot is valid
var scene_name: String

# The upper left corner of the hotspot position
var upper_left: Vector2

# The lower right corner of the hotspot position
var lower_right: Vector2


# A helper method to validate if the specified position is inside the hotspot
#
# **Arguments**
#
# - current_scene: The name of the current scene
# - position: The position in question
func is_over(current_scene: String, position: Vector2) -> bool:
	if current_scene == scene_name and \
		position >= upper_left and \
		position <= lower_right:
			return true
	return false


func _get_property_list():
	var properties = []
	properties.append({
		"name": "name",
		"type": TYPE_STRING
	})
	properties.append({
		"name": "scene_name",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tscn"
	})
	properties.append({
		"name": "upper_left",
		"type": TYPE_VECTOR2
	})
	properties.append({
		"name": "lower_right",
		"type": TYPE_VECTOR2
	})
	return properties
