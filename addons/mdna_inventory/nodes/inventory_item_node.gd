# The inventory item
class_name InventoryItemNode
extends TextureButton


# Emitted, when a hotspot was triggered
signal triggered_hotspot

# Emitted, when another inventory item was triggered
signal triggered_inventory_item


# The corresponding resource
var item: InventoryItem


# Wether we're on touch devices
onready var _is_touch: bool = OS.has_touchscreen_ui_hint()


# Handle touch/press inputs on hotspots
func _input(event):
	if MdnaInventory.selected_item == self:
		var position: Vector2
		var action: bool
		if event is InputEventMouseButton \
				and (event as InputEventMouseButton).pressed \
				and (event as InputEventMouseButton).button_index == \
						BUTTON_LEFT:
			position = get_viewport().get_mouse_position()
			action = true
		elif event is InputEventScreenTouch \
				and (event as InputEventScreenTouch).pressed:
			position = (event as InputEventScreenTouch).position
			action = true
		
		if action:
			var trigger_hotspot = _is_over_hotspot(position)
			if trigger_hotspot != null:
				emit_signal("triggered_hotspot", trigger_hotspot, item)


# Handle mouse cursor changes when the item is over a hotspot
func _process(delta):
	if ! _is_touch and MdnaInventory.selected_item == self:
		var trigger_hotspot = _is_over_hotspot(
			get_viewport().get_mouse_position()
		)
		if trigger_hotspot == null:
			Input.set_custom_mouse_cursor(item.image_normal)
		else:
			Input.set_custom_mouse_cursor(item.image_active)


func configure(p_item: InventoryItem):
	item = p_item
	texture_normal = item.image_normal
	connect("pressed", self, "_on_InventoryItem_pressed")


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
		texture_normal = null
		MdnaInventory.selected_item = self
		if _is_touch:
			texture_normal = item.image_active
		else:
			Input.set_custom_mouse_cursor(item.image_normal)


# A helper function that looks through the list of hotspots wether the 
# hotspot is valid for the current scene and the specified position is
# inside the hotspot
#
# **Arguments**
#
# - position: The position to check against all valid hotspots
func _is_over_hotspot(position: Vector2) -> TriggerHotspot:
	if position.y <= MdnaInventory.get_node("Canvas/Panel").rect_size.y:
		# Positions over the inventory area aren't checked per default
		return null
	for hotspot in item.trigger_hotspots:
		if (hotspot as TriggerHotspot).is_over(get_tree() \
				.current_scene.filename, position):
			return hotspot
	return null
