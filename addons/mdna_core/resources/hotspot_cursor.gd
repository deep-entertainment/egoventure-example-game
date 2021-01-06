tool
class_name HotspotCursor
extends Resource


# The hotspot type
export(
	String, 
	"go_forward", 
	"turn_right", 
	"turn_left", 
	"corner_right", 
	"corner_left", 
	"action", 
	"go_backwards",
	"look"
) var hotspot_type = "go_forward"

# The mouse cursor image
export(Texture) var cursor

# The mouse cursor hotspot
export(Vector2) var cursor_hotspot
