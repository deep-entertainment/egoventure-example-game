tool
class_name HotspotCursor
extends Resource


# The hotspot type
export(
	preload("res://addons/mdna_core/cursors.gd").Type
) var hotspot_type = preload("res://addons/mdna_core/cursors.gd").Type.GO_FORWARD

# The mouse cursor image
export(Texture) var cursor

# The mouse cursor hotspot
export(Vector2) var cursor_hotspot
