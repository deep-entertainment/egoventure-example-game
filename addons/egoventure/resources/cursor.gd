@tool
# The mouse cursor configuration
class_name Cursor
extends Resource


# The cursor type
@export var type: CursorType.Type = CursorType.Type.GO_FORWARD

# The mouse cursor image
@export var cursor: Texture2D

# The mouse cursor hotspot
@export var cursor_hotspot: Vector2
