# A button that triggers a dialog
tool
class_name DialogHotspot, \
		"res://addons/mdna_core/images/dialog_hotspot.svg"
extends RichTextLabel


# The dialog to play
var dialog: DialogResource

# Wether the dialog is enabled
var enabled: bool = true setget _set_enabled


# Connect the pressed signal to the pressed func
func _ready():
	connect("pressed", self, "_on_pressed")
	_set_enabled(enabled)


func _set_enabled(value: bool):
	enabled = value
	_update_color()
	

func _update_color():
	if enabled:
		add_color_override(
			"default_color",
			get_color(
				"dialog_hotspot_font_color",
				"RichTextLabel"
			)
		)
	else:
		add_color_override(
			"default_color",
			get_color(
				"dialog_hotspot_disabled_font_color",
				"RichTextLabel"
			)
		)


# Set theme and add overrides
func _enter_tree():
	if not Engine.editor_hint:
		if Parrot.theme == null:
			yield(Parrot, "parrot_configured")
		theme = Parrot.theme
		add_font_override(
			"normal_font",
			get_font(
				"dialog_hotspot_normal_font",
				"RichTextLabel"
			)
		)
		add_font_override(
			"bold_font",
			get_font(
				"dialog_hotspot_bold_font",
				"RichTextLabel"
			)
		)
		_update_color()
		mouse_default_cursor_shape = Parrot.dialog_hotspot_cursor_shape


# Play dialog
func _gui_input(event):
	if event is InputEventMouseButton and \
			not (event as InputEventMouseButton).pressed:
		if (event as InputEventMouseButton).button_index == BUTTON_RIGHT:
			MainMenu.toggle()
		else:
			release_focus()
			Parrot.play(dialog)
			

# Return properties
func _get_property_list():
	return [{
		"name": "dialog",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "DialogResource"
	}, {
		"name": "enabled",
		"type": TYPE_BOOL
	}]
