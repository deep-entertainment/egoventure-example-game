tool
class_name LookHotspot, "res://addons/mdna_core/images/look_hotspot.svg"
extends TextureButton


# The dialog resource that should be played by Parrot
export (String, FILE, "*.tres") var dialog


# Connect to the relevant signals and gather the cursors from configuration
func _ready():
	connect("pressed", self, "_on_pressed")
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[Cursors.Type.LOOK]


# The hotspot was clicked, play the dialog
func _on_pressed():
	Parrot.play(load(dialog))
	
