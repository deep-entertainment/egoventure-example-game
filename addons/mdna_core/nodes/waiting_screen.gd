extends CanvasLayer


# Hide the screen as default
func _ready():
	$Screen.hide()
	$Screen.theme = MdnaCore.configuration.theme


# Show the waiting screen
func show():
	$Screen.show()
	

# Hide the waiting screen
func hide():
	$Screen.hide()


# Update the progess on the screen
func set_progress(value: float):
	$Screen/Panel/VBoxContainer/ProgressBar.value = value
	if value == 100:
		hide()


# Set the waiting image
func set_image(image: Texture):
	$Screen/Panel/VBoxContainer/TextureRect.texture = image
