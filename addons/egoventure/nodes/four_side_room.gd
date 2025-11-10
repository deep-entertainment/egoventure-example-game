@tool
# A scene, that can be instantiated in a scene and features a room
# with four different sides with automatic view navigation using a Camera2D
class_name FourSideRoom
extends Node2D


# Triggered when the user switches the view
signal view_changed(old_view, new_view)


# The front view
const VIEW_FRONT = "front"

# The right view
const VIEW_RIGHT = "right"

# The backwards view
const VIEW_BACK = "back"

# The left view
const VIEW_LEFT = "left"

# An unset view
const VIEW_UNSET = ""


# The default/starting view of the four views
@export_enum ("front", "right", "back", "left") var default_view:String = "front"

# The texture for the front view
@export var front_texture:Texture2D : set = _front_texture_set

# The texture for the right view
@export var right_texture:Texture2D : set = _right_texture_set

# The texture for the backwards view
@export var back_texture:Texture2D : set = _back_texture_set

# The texture for the left view
@export var left_texture:Texture2D : set = _left_texture_set

# Whether navigation features are enabled in this room
@export var enable_navigation:bool = true: set = _set_navigation


# The current view shown to the player
var current_view = VIEW_UNSET: set = _set_current_view


# The size of the viewport
var _viewport_size


# Set the viewport size as a reference
func _init():
	_viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)


# Update the cache and position the navigation tools
func _ready():
	if not Engine.is_editor_hint():
		$Camera/Left.position.x = 0
		$Camera/Left.position.y = EgoVenture.configuration.inventory_size
		$Camera/Left.size.x = EgoVenture.configuration\
				.tools_navigation_width
		$Camera/Left.size.y = _viewport_size.y -\
				EgoVenture.configuration.inventory_size
		$Camera/Right.position.x = _viewport_size.x -\
				EgoVenture.configuration.tools_navigation_width
		$Camera/Right.position.y = EgoVenture.configuration.inventory_size
		$Camera/Right.size.x = EgoVenture.configuration\
				.tools_navigation_width
		$Camera/Right.size.y = _viewport_size.y -\
				EgoVenture.configuration.inventory_size
		EgoVenture.connect("requested_view_change", Callable(self, "_set_current_view"))


# Properly position the different views
# Navigate to the default view when we're not in the editor
# Also check EgoVenture.target_view wether we need to directly switch
# to a different view
func _enter_tree():
	if not Engine.is_editor_hint():
		if EgoVenture.target_view != VIEW_UNSET:
			_set_current_view(EgoVenture.target_view)
		else:
			_set_current_view(default_view)
	$Views/Front.position = Vector2(0, _viewport_size.y * -1)
	$Views/Right.position = Vector2(_viewport_size.x, 0)
	$Views/Back.position = Vector2(0, _viewport_size.y)
	$Views/Left.position = Vector2(_viewport_size.x * -1, 0)
	

# Set the current view
#
# ** Parameters **
#
# - value: The current view
func _set_current_view(value: String):
	emit_signal("view_changed", current_view, value)
	current_view = value
	EgoVenture.current_view = value
	match current_view:
		VIEW_FRONT: $Camera.position = Vector2(0, _viewport_size.y * -1)
		VIEW_RIGHT: $Camera.position = Vector2(_viewport_size.x, 0)
		VIEW_BACK: $Camera.position = Vector2(0, _viewport_size.y)
		VIEW_LEFT: $Camera.position = Vector2(_viewport_size.x * -1, 0)


# Disable or enable navigation in this room
#
# ** Parameters **
#
# - p_enable_navigation: Whether to enable the navigation features
func _set_navigation(p_enable_navigation: bool):
	enable_navigation = p_enable_navigation
	$Camera/Left.show_indicator = enable_navigation
	$Camera/Left.visible = enable_navigation
	$Camera/Left.disabled = not enable_navigation
	$Camera/Right.show_indicator = enable_navigation
	$Camera/Right.visible = enable_navigation
	$Camera/Right.disabled = not enable_navigation


# Set the texture for the front view
#
# ** Parameters **
# 
# - value: The texture to set
func _front_texture_set(value: Texture2D):
	front_texture = value
	$Views/Front.texture = front_texture
	

# Set the texture for the right view
#
# ** Parameters **
# 
# - value: The texture to set
func _right_texture_set(value: Texture2D):
	right_texture = value
	$Views/Right.texture = right_texture
	

# Set the texture for the backwards view
#
# ** Parameters **
# 
# - value: The texture to set
func _back_texture_set(value: Texture2D):
	back_texture = value
	$Views/Back.texture = back_texture


# Set the texture for the left view
#
# ** Parameters **
# 
# - value: The texture to set
func _left_texture_set(value: Texture2D):
	left_texture = value
	$Views/Left.texture = left_texture


# Handle camera move when the right hotspot was pressed
func _on_Right_activate():
	match current_view:
			VIEW_FRONT: _set_current_view(VIEW_RIGHT)
			VIEW_RIGHT: _set_current_view(VIEW_BACK)
			VIEW_BACK: _set_current_view(VIEW_LEFT)
			VIEW_LEFT: _set_current_view(VIEW_FRONT)


# Handle camera move when the left hotspot was pressed
func _on_Left_activate():
	match current_view:
		VIEW_FRONT: _set_current_view(VIEW_LEFT)
		VIEW_LEFT: _set_current_view(VIEW_BACK)
		VIEW_BACK: _set_current_view(VIEW_RIGHT)
		VIEW_RIGHT: _set_current_view(VIEW_FRONT)
