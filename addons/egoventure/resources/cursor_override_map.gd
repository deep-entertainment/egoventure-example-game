@tool
class_name CursorOverrideMap
extends Resource

@export var cursor_type_override: CursorType.Type
@export var additional_cursor: int


func _init() -> void:
	cursor_type_override = CursorType.Type.CUSTOM1
	additional_cursor = 0
