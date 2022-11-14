# A scene, that can be instantiated in a scene and features a room
# with up to eight different sides with automatic view navigation using a Camera2D
@tool
class_name EightSideRoom
extends Node2D

# Triggered when the user switches the view
signal view_changed(old_view, new_view)

# view constants
const VIEW_FRONTLEFT = "frontleft"
const VIEW_FRONT = "front"
const VIEW_FRONTRIGHT = "frontright"
const VIEW_RIGHT = "right"
const VIEW_BACKRIGHT = "backright"
const VIEW_BACK = "back"
const VIEW_BACKLEFT = "backleft"
const VIEW_LEFT = "left"

# An unset view
const VIEW_UNSET = ""

# Distance between textures to allow overlapping hotspot areas
const TEXTURE_DISTANCE = 100

# Dictionary used to map view constant to index (and back)
var view_dict = {VIEW_FRONTLEFT : 0, VIEW_FRONT : 1, VIEW_FRONTRIGHT : 2, \
				VIEW_RIGHT : 3, VIEW_BACKRIGHT : 4, VIEW_BACK : 5, \
				VIEW_BACKLEFT : 6, VIEW_LEFT : 7}

# The default/starting view of the four views
# issue https://github.com/godotengine/godot/issues/54828
@export_enum("frontleft", "front", "frontright", "right", "backright", "back", "backleft", "left") var default_view: String = VIEW_FRONT

# The texture for the front view
@export var frontleft_texture: Texture2D:
	set(mod_value):
		_frontleft_texture_set(mod_value)
@export var front_texture: Texture2D:
	set(mod_value):
		_front_texture_set(mod_value)
@export var frontright_texture: Texture2D:
	set(mod_value):
		_frontright_texture_set(mod_value)
@export var right_texture: Texture2D:
	set(mod_value):
		_right_texture_set(mod_value)
@export var backright_texture: Texture2D:
	set(mod_value):
		_backright_texture_set(mod_value)
@export var back_texture: Texture2D:
	set(mod_value):
		_back_texture_set(mod_value)
@export var backleft_texture: Texture2D:
	set(mod_value):
		_backleft_texture_set(mod_value)
@export var left_texture: Texture2D:
	set(mod_value):
		_left_texture_set(mod_value)

# Whether navigation features are enabled in this room
@export var enable_navigation: bool = true :
	get:
		return enable_navigation # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_navigation

# The current view shown to the player
var current_view = VIEW_UNSET :
	get:
		return current_view # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_current_view

# The size of the viewport
var _viewport_size


# Set the viewport size as a reference
func _init():
	_viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height")
	)


# Update the cache and position the navigation tools
func _ready():
	if not Engine.editor_hint:
		EgoVenture.update_cache()
		$Camera3D/Left.position.x = 0
		$Camera3D/Left.position.y = EgoVenture.configuration.inventory_size
		$Camera3D/Left.size.x = EgoVenture.configuration\
				.tools_navigation_width
		$Camera3D/Left.size.y = _viewport_size.y -\
				EgoVenture.configuration.inventory_size
		$Camera3D/Right.position.x = _viewport_size.x -\
				EgoVenture.configuration.tools_navigation_width
		$Camera3D/Right.position.y = EgoVenture.configuration.inventory_size
		$Camera3D/Right.size.x = EgoVenture.configuration\
				.tools_navigation_width
		$Camera3D/Right.size.y = _viewport_size.y -\
				EgoVenture.configuration.inventory_size
		EgoVenture.connect("requested_view_change",Callable(self,"_set_current_view"))


# Properly position the different views
# Navigate to the default view when we're not in the editor
# Also check EgoVenture.target_view wether we need to directly switch
# to a different view
func _enter_tree():
	if not Engine.editor_hint:
		if EgoVenture.target_view != VIEW_UNSET:
			_set_current_view(EgoVenture.target_view)
		else:
			_set_current_view(default_view)
	$Views/Front.position = Vector2(0, _viewport_size.y * -1 - TEXTURE_DISTANCE)
	$Views/Right.position = Vector2(_viewport_size.x + TEXTURE_DISTANCE, 0)
	$Views/Back.position = Vector2(0, _viewport_size.y + TEXTURE_DISTANCE)
	$Views/Left.position = Vector2(_viewport_size.x * -1 - TEXTURE_DISTANCE, 0)
	$Views/FrontLeft.position = Vector2(_viewport_size.x * -1 - TEXTURE_DISTANCE, _viewport_size.y * -1 - TEXTURE_DISTANCE)
	$Views/FrontRight.position = Vector2(_viewport_size.x + TEXTURE_DISTANCE, _viewport_size.y * -1 - TEXTURE_DISTANCE)
	$Views/BackLeft.position = Vector2(_viewport_size.x * -1 - TEXTURE_DISTANCE, _viewport_size.y + TEXTURE_DISTANCE)
	$Views/BackRight.position = Vector2(_viewport_size.x + TEXTURE_DISTANCE, _viewport_size.y + TEXTURE_DISTANCE)
	

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
		VIEW_FRONT: $Camera3D.position = Vector2(0, _viewport_size.y * -1 - TEXTURE_DISTANCE)
		VIEW_RIGHT: $Camera3D.position = Vector2(_viewport_size.x + TEXTURE_DISTANCE, 0)
		VIEW_BACK: $Camera3D.position = Vector2(0, _viewport_size.y + TEXTURE_DISTANCE)
		VIEW_LEFT: $Camera3D.position = Vector2(_viewport_size.x * -1 - TEXTURE_DISTANCE, 0)
		VIEW_FRONTLEFT: $Camera3D.position = Vector2(_viewport_size.x * -1 - TEXTURE_DISTANCE, _viewport_size.y * -1 - TEXTURE_DISTANCE)
		VIEW_FRONTRIGHT: $Camera3D.position = Vector2(_viewport_size.x + TEXTURE_DISTANCE, _viewport_size.y * -1 - TEXTURE_DISTANCE)
		VIEW_BACKLEFT: $Camera3D.position = Vector2(_viewport_size.x * -1 - TEXTURE_DISTANCE, _viewport_size.y + TEXTURE_DISTANCE)
		VIEW_BACKRIGHT: $Camera3D.position = Vector2(_viewport_size.x + TEXTURE_DISTANCE, _viewport_size.y + TEXTURE_DISTANCE)


# Disable or enable navigation in this room
#
# ** Parameters **
#
# - p_enable_navigation: Whether to enable the navigation features
func _set_navigation(p_enable_navigation: bool):
	enable_navigation = p_enable_navigation
	$Camera3D/Left.show_indicator = enable_navigation
	$Camera3D/Left.visible = enable_navigation
	$Camera3D/Left.disabled = not enable_navigation
	$Camera3D/Right.show_indicator = enable_navigation
	$Camera3D/Right.visible = enable_navigation
	$Camera3D/Right.disabled = not enable_navigation


# Check whether texture for this view is defined
#
# ** Parameters **
# 
# - index: The index representing the view (0 = frontleft, 1 = front, ...)
func _has_texture(index: int) -> bool:
	match index:
		0: return frontleft_texture != null
		1: return front_texture != null
		2: return frontright_texture != null
		3: return right_texture != null
		4: return backright_texture != null
		5: return back_texture != null
		6: return backleft_texture != null
		7: return left_texture != null
	return false


# Set the texture for the frontleft view
#
# ** Parameters **
# 
# - value: The texture to set
func _frontleft_texture_set(value: Texture2D):
	frontleft_texture = value
	$Views/FrontLeft.texture = frontleft_texture


# Set the texture for the front view
#
# ** Parameters **
# 
# - value: The texture to set
func _front_texture_set(value: Texture2D):
	front_texture = value
	$Views/Front.texture = front_texture


# Set the texture for the frontright view
#
# ** Parameters **
# 
# - value: The texture to set
func _frontright_texture_set(value: Texture2D):
	frontright_texture = value
	$Views/FrontRight.texture = frontright_texture


# Set the texture for the right view
#
# ** Parameters **
# 
# - value: The texture to set
func _right_texture_set(value: Texture2D):
	right_texture = value
	$Views/Right.texture = right_texture


# Set the texture for the backwards right view
#
# ** Parameters **
# 
# - value: The texture to set
func _backright_texture_set(value: Texture2D):
	backright_texture = value
	$Views/BackRight.texture = backright_texture


# Set the texture for the backwards view
#
# ** Parameters **
# 
# - value: The texture to set
func _back_texture_set(value: Texture2D):
	back_texture = value
	$Views/Back.texture = back_texture


# Set the texture for the backwards left view
#
# ** Parameters **
# 
# - value: The texture to set
func _backleft_texture_set(value: Texture2D):
	backleft_texture = value
	$Views/BackLeft.texture = backleft_texture


# Set the texture for the left view
#
# ** Parameters **
# 
# - value: The texture to set
func _left_texture_set(value: Texture2D):
	left_texture = value
	$Views/Left.texture = left_texture


# Handle camera move when the right hotspot was pressed to next available texture (clockwise)
func _on_Right_activate():
	var curr_index = view_dict[current_view]
	var next_index = curr_index
	while true:
		next_index = next_index + 1
		if (next_index > 7):
			next_index = 0
		if _has_texture(next_index):
			break
		if next_index == curr_index: # to prevent endless loop, stays in same view then
			break
	_set_current_view(view_dict.keys()[next_index])


# Handle camera move when the left hotspot was pressed to next available texture (counterclockwise)
func _on_Left_activate():
	var curr_index = view_dict[current_view]
	var next_index = curr_index
	while true:
		next_index = next_index - 1
		if (next_index < 0):
			next_index = 7
		if _has_texture(next_index):
			break
		if next_index == curr_index: # to prevent endless loop, stays in same view then
			break
	_set_current_view(view_dict.keys()[next_index])
