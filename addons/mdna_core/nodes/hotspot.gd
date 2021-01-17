# A simple hotspot which can also move to a target scene upon
# pressing
tool
class_name Hotspot, "res://addons/mdna_core/images/hotspot.svg"
extends TextureButton


# The hotspot type
export(Cursors.Type) var hotspot_type = Cursors.Type.GO_FORWARD \
		setget _set_hotspot_type


# If set, changes to the given scene
export(String, FILE, "*.tscn") var target_scene = ""


# If set, changes the target view before going to the target scene
export(
	String, 
	"front", 
	"right",
	"back",
	"left"
) var target_view = FourSideRoom.VIEW_UNSET


# The hotspot indicator
var _hotspot_indicator: Sprite


# Connect to the cursors_configured signal to set the hotspot indicator
# texture
func _init():
	_hotspot_indicator = Sprite.new()
	add_child(_hotspot_indicator)
	_hotspot_indicator.hide()
	_hotspot_indicator.position = rect_size / 2
	Cursors.connect("cursors_configured", self, "_set_hotspot_indicator")


# Connect the pressed signal
func _ready():
	if target_scene != "":
		connect("pressed", self, "_pressed")
		

func _input(event):
	if event.is_action_pressed("hotspot_indicator"):
		_hotspot_indicator.show()
	elif event.is_action_released("hotspot_indicator"):
		_hotspot_indicator.hide()


# Set the default value of a new hotspot
func _enter_tree():
	_set_hotspot_type(hotspot_type)


# Set the hotspot type
# 
# ** Parameters **
# 
# - type: The type to set
func _set_hotspot_type(type):
	hotspot_type = type
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[type]


# Switch to the target scene with the configured target view
func _pressed():
	release_focus()
	MdnaCore.target_view = target_view
	if target_scene != "":
		MdnaCore.change_scene(target_scene)


# Set the texture of the hotspot indicator after the cursors have been 
# configured
func _set_hotspot_indicator():
	_hotspot_indicator.texture = Cursors.get_cursor_texture(hotspot_type) 
