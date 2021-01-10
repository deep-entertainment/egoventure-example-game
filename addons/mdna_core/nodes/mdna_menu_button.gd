# A button for the Mdna main menu
tool
class_name MdnaMenuButton
extends Button

# Create custom styleboxes for normal and hover
func _ready():
	add_stylebox_override("normal", get_stylebox("menu_button_normal", "Button"))
	add_stylebox_override("hover", get_stylebox("menu_button_hover", "Button"))
