class_name TestScriptStep
extends Resource

@export var scene_name: String = ""
@export var scene_view: String = ""
@export var action: int
@export var mouse_position: Vector2
@export var mouse_hidden: bool = false
@export var item_title: String = ""
@export var node_type: String = ""
@export var node_path: String = ""


func _to_string() -> String:
	var action_name: String
	if action == 0:
		action_name = "left click"
	elif action == 1:
		action_name = "right click"
	elif action == 2:
		action_name = "show inventory"
	else:
		action_name = ""
		
	return("Scene: %s, View: %s, Action: %s, Position: (%d, %d), NodePath: %s, InvItem: %s" %
		[scene_name, scene_view, action_name, mouse_position.x, mouse_position.y,
		node_path, item_title])
