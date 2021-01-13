# The detail view of an inventory item
extends CanvasLayer


func _ready():
	$Panel.add_stylebox_override(
		"panel",
		$Panel.get_stylebox(
			"detail_view",
			"Panel"
		)
	)
	$Panel.hide()


# Hide the view again on click/touch
func _on_panel_gui_input(event: InputEvent):
	if $Panel.visible:
		$Panel.accept_event()
		if event is InputEventMouseButton and \
				event.is_pressed():
			$Panel.hide()
		

# Show the item
#
# ** Parameters **
#
# - item: The inventory item to display
func show(item: InventoryItem):
	$Panel/VBox/Image.texture = item.image_big
	$Panel/VBox/Description.text = item.description
	$Panel.show()
