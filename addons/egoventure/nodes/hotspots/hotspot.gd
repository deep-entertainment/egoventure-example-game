@tool
# A simple hotspot which can also move to a target scene upon
# pressing
@icon("res://addons/egoventure/images/hotspot.svg")
class_name Hotspot
extends TextureButton


# A signal that can be connected to for custom actions of
# this hotspot
signal activate


# The cursor type
@export var cursor_type = Cursors.Type.GO_FORWARD : set = _set_cursor_type

# If set, changes to the given scene
@export var target_scene = "" # (String, FILE, "*.tscn")

# If set, changes the target view before going to the target scene
@export_enum(
	"front",
	"right",
	"back",
	"left",
	"frontleft", 
	"frontright",
	"backright",
	"backleft"
) var target_view: String = FourSideRoom.VIEW_UNSET

# If set, plays a sound effect when the hotspot is pressed and the
# scene is changed
@export var effect: AudioStream = null

# Show this hotspot depending on the boolean value of this state
# variable
@export var visibility_state: String = ""

# Whether to show the hotspot indicator or not
@export var show_indicator: bool = true


# The hotspot indicator
var _hotspot_indicator: Sprite2D


# Connect to the cursors_configured signal to set the hotspot indicator
# texture
func _init():
	_hotspot_indicator = Sprite2D.new()
	add_child(_hotspot_indicator)
	_hotspot_indicator.hide()
	button_mask = MOUSE_BUTTON_MASK_LEFT
	connect("pressed", self._on_pressed)


# Update hotspot indicator
func _process(_delta):
	_hotspot_indicator.position = size / 2
	_hotspot_indicator.texture = Cursors.get_cursor_texture(cursor_type) 
	_hotspot_indicator.rotation_degrees = rotation * -1
	_check_visibility()
			

# Hotspot indicator toggle
func _input(event):
	if show_indicator and \
			(not DetailView.is_visible or DetailView.is_ancestor_of(self)) and \
			not WaitingScreen.is_displayed():
		if event.is_action_pressed("hotspot_indicator"):
			Speedy.hidden = true
			_hotspot_indicator.show()
		elif event.is_action_released("hotspot_indicator"):
			Speedy.hidden = false
			_hotspot_indicator.hide()


# Set the default value of a new hotspot
func _enter_tree():
	_set_cursor_type(cursor_type)
	call_deferred("_check_state")


# Sanity check the visibility state parameter
func _check_state():
	if not Engine.is_editor_hint():
		var state = EgoVenture.state
		if not visibility_state.is_empty() and \
				(
					not (visibility_state in state) or
					not state.get(visibility_state) is bool
				):
			assert(
				false, 
				(
					"Hotspot visibility state variable %s " +
					"of node %s not found or is not bool"
				) % [
					visibility_state,
					name
				]
			)
		_check_visibility()


# Set the cursor type
# 
# ** Parameters **
# 
# - type: The type to set
func _set_cursor_type(type):
	cursor_type = type
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[type]
	if Cursors.get_cursor_texture(cursor_type) == null:
		await Cursors.cursors_configured


# Switch to the target scene with the configured target view
func _on_pressed():
	# Add node information to test script when recording
	if EgoVenture.is_test_run_enabled() and TestRun.is_recording():
		TestRun.test_script.set_node_info(self.get_class(), self.get_path())
	# Process pressed event
	release_focus()
	if Inventory.selected_item == null:
		if effect:
			Boombox.play_effect(effect)
		if get_signal_connection_list("activate").size() > 0:
			emit_signal("activate")
		elif target_scene != "":
			EgoVenture.target_view = target_view
			EgoVenture.change_scene(target_scene)


# Check wether the hotspot should be shown or hidden
func _check_visibility():
	if not visibility_state.is_empty() and "state" in EgoVenture:
		if visibility_state in EgoVenture.state and \
				EgoVenture.state.get(visibility_state) is bool:
			if not visible == EgoVenture.state.get(visibility_state):
				visible = EgoVenture.state.get(visibility_state)
				# update cursor state after visibility was changed
				get_viewport().update_mouse_cursor_state()
