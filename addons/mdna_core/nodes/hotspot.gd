tool
class_name Hotspot, "res://addons/mdna_core/images/hotspot.svg"
extends TextureButton


# The hotspot type
export(
	String, 
	"go_forward", 
	"turn_right", 
	"turn_left", 
	"corner_right", 
	"corner_left", 
	"action", 
	"go_backwards",
	"look"
) var hotspot_type = "go_forward"

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


func _ready():
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited", self, "_mouse_exited")
	if target_scene != "":
		connect("pressed", self, "_pressed")
	
	
func _pressed():
	MdnaCore.target_view = target_view
	if target_scene != "":
		MdnaCore.change_scene(target_scene)
	

func _mouse_entered():
	for cursor in MdnaCore.configuration.hotspot_cursors:
		if (cursor as HotspotCursor).hotspot_type == hotspot_type:
			var found_cursor = cursor as HotspotCursor
			Input.set_custom_mouse_cursor(
				found_cursor.cursor,
				Input.CURSOR_ARROW,
				found_cursor.cursor_hotspot
			)


func _mouse_exited():
	Input.set_custom_mouse_cursor(
		MdnaCore.configuration.inventory_configuration.mouse_cursor,
		Input.CURSOR_ARROW,
		MdnaCore.configuration.inventory_configuration.hotspot_cursor
	)
