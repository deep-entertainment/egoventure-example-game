# The inventory item as a graphic node
class_name InventoryItemNode
extends TextureButton


# Emitted, when another inventory item was triggered
signal triggered_inventory_item


# The corresponding resource
var item: InventoryItem


# Wether we're on touch devices
onready var _is_touch: bool = OS.has_touchscreen_ui_hint()


# Configure this item and connect the required signals
#
# ** Parameters **
#
# - p_item: The InventoryItem resource this item is based on 
func configure(p_item: InventoryItem):
	item = p_item
	texture_normal = item.image_normal
	connect("pressed", self, "_on_InventoryItem_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


# Show active image on inventory item hover
func _on_mouse_entered():
	if MdnaInventory.selected_item != null and \
			MdnaInventory.selected_item != self:
		Input.set_custom_mouse_cursor(
			MdnaInventory.selected_item.item.image_active,
			Input.CURSOR_ARROW,
			Vector2(32, 32)
		)
	
	
# Reset inventory item mouse cursor
func _on_mouse_exited():
	if MdnaInventory.selected_item != null and \
			MdnaInventory.selected_item != self:
		Input.set_custom_mouse_cursor(
			MdnaInventory.selected_item.item.image_normal,
			Input.CURSOR_ARROW,
			Vector2(32, 32)
		)


# Handle clicks on another inventory item
func _on_InventoryItem_pressed():
	if MdnaInventory.selected_item == self:
		# On touch, selecting the same item again, deselects it
		MdnaInventory.selected_item = null
		texture_normal = item.image_normal
	elif MdnaInventory.selected_item != null:
		# Another item was triggered with the current one
		emit_signal(
			"triggered_inventory_item", 
			MdnaInventory.selected_item.item, 
			item
		)
	else:
		# Select this inventory item
		MdnaInventory.selected_item = self
		if _is_touch:
			texture_normal = item.image_active
		else:
			modulate.a = 0
			Input.set_custom_mouse_cursor(
				item.image_normal,
				Input.CURSOR_ARROW,
				(item.image_normal as Texture).get_size() / 2
			)

