# A hotspot that can be used for forward/backward hotspots
# and has a predefined size
@tool
class_name WalkHotspot
extends Hotspot
@icon("res://addons/egoventure/images/walk_hotspot.svg")


# Set the walk hotspot size, if configured
func _enter_tree():
	print(size)
	if size == Vector2(0,0) and ProjectSettings.has_setting(
			"EgoVenture/hotspots/walk_hotspot_size"
		):
		# call the actual resize deferred to override autolayout
		call_deferred("_set_hotspot_size")


# Set the size of the rect
func _set_hotspot_size():
	set_size(
		ProjectSettings.get_setting("EgoVenture/hotspots/walk_hotspot_size")
	)
