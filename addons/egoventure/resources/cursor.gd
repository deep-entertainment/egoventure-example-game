# The mouse cursor configuration
@tool
class_name Cursor
extends Resource

# The cursor type
@export var type: Cursors.Type = Cursors.Type.GO_FORWARD

# The mouse cursor image
@export var cursor: Texture2D

# The mouse cursor hotspot
@export var cursor_hotspot: Vector2
