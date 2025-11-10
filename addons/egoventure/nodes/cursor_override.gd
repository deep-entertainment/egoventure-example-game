@tool
class_name CursorOverride 
extends Node

@export var map: Array[CursorOverrideMap]


func _enter_tree() -> void:
	# No mapping needed in editor
	if Engine.is_editor_hint():
		return
	for item in map:
		Cursors.override(
				item.cursor_type_override, 
				Cursors.additional_cursors[item.additional_cursor].cursor,
				Cursors.additional_cursors[item.additional_cursor].cursor_hotspot)


func _exit_tree() -> void:
	for item in map:
		Cursors.reset(item.cursor_type_override)
