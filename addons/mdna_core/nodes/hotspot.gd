# A simple hotspot which can also move to a target scene upon
# pressing
tool
class_name Hotspot, "res://addons/mdna_core/images/hotspot.svg"
extends TextureButton


# The hotspot type
export(Cursors.Type) var hotspot_type = \
		Cursors.Type.GO_FORWARD setget _set_hotspot_type


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


# Connect the pressed signal
func _ready():
	if target_scene != "":
		connect("pressed", self, "_pressed")


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
	MdnaCore.target_view = target_view
	if target_scene != "":
		MdnaCore.change_scene(target_scene)

