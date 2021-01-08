tool
class_name LookHotspot, "res://addons/mdna_core/images/look_hotspot.svg"
extends TextureButton


# The dialog resource that should be played by Parrot
export (String, FILE, "*.tres") var dialog


# The look hotspot cursor
var look_cursor: HotspotCursor


# The default cursor texture
var default_cursor: Texture


# The default cursor's hotspot
var default_cursor_hotspot: Vector2


# Connect to the relevant signals and gather the cursors from configuration
func _ready():
	connect("pressed", self, "_on_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	for cursor in MdnaCore.configuration.hotspot_cursors:
		if (cursor as HotspotCursor).hotspot_type == "look":
			look_cursor = cursor
	
	default_cursor = MdnaCore.configuration.inventory_configuration.mouse_cursor
	default_cursor_hotspot = \
			MdnaCore.configuration.inventory_configuration.hotspot_cursor
	

# Show the look cursor
func _on_mouse_entered():
	if MdnaInventory.selected_item == null:
		Input.set_custom_mouse_cursor(
			look_cursor.cursor,
			Input.CURSOR_ARROW,
			look_cursor.cursor_hotspot
		)
		

# Show the default cursor again
func _on_mouse_exited():
	if MdnaInventory.selected_item == null:
		Input.set_custom_mouse_cursor(
			default_cursor,
			Input.CURSOR_ARROW,
			default_cursor_hotspot
		)


# The hotspot was clicked, play the dialog
func _on_pressed():
	if MdnaInventory.selected_item == null:
		Parrot.play(load(dialog))
	
