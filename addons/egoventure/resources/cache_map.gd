# CacheMap
tool
class_name CacheMap
extends Resource


# List of scenes and cache parameters
# key = scene name
# value = array of
#         - estimated scene size in kB
#         - list of adjacent scenes
var map: Dictionary


# Build the property list
func _get_property_list():
	var properties = []
	properties.append({
		name = "map",
		type = TYPE_DICTIONARY
	})
	return properties
