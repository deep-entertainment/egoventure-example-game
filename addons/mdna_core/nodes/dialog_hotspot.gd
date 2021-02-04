# A button that triggers a dialog
tool
class_name DialogHotspot, \
		"res://addons/mdna_core/images/dialog_hotspot.svg"
extends RichTextLabel


signal pressed


# The dialog to play
var dialog: DialogResource 

# Wether the question was already asked
var asked: bool = false setget _set_asked


# Connect hover signals
func _init():
	connect("mouse_entered", self, "_set_hover")
	connect("mouse_exited", self, "_update_color")


# Set default value for asked
func _ready():
	_set_asked(asked)


# Set the asked value and update the color
func _set_asked(value: bool):
	asked = value
	_update_color()


# Update the color based on asked/not asked
func _update_color():
	if Engine.editor_hint:
		add_color_override(
			"default_color",
			Color.black
		)
	elif not asked:
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
				"dialog_hotspot_asked_font_color",
				"RichTextLabel"
			)
		)
		

# Set hover font color
func _set_hover():
	add_color_override(
		"default_color",
		get_color(
			"dialog_hotspot_hover_font_color",
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
		add_stylebox_override(
			"normal",
			StyleBoxEmpty.new()
		)
		_update_color()
		mouse_default_cursor_shape = Parrot.dialog_hotspot_cursor_shape
	else:
		add_font_override(
			"normal_font",
			preload("res://addons/mdna_core/font/default_font.tres")
		)
		var stylebox = StyleBoxFlat.new()
		stylebox.draw_center = false
		stylebox.border_width_left = 2
		stylebox.border_width_top = 2
		stylebox.border_width_right = 2
		stylebox.border_width_bottom = 2
		stylebox.border_color = Color.red
		add_stylebox_override(
			"normal",
			stylebox
		)


# Play dialog
func _gui_input(event):
	if event is InputEventMouseButton and \
			not (event as InputEventMouseButton).pressed:
		if (event as InputEventMouseButton).button_index == BUTTON_RIGHT:
			MainMenu.toggle()
		else:
			release_focus()
			if (dialog):			
				Parrot.play(dialog)
			else:
				emit_signal("pressed")


# Return properties
func _get_property_list():
	return [{
		"name": "dialog",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "DialogResource"
	}, {
		"name": "asked",
		"type": TYPE_BOOL
	}]
