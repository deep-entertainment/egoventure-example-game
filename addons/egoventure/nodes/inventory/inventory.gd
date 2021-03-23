# EgoVenture Inventory system
extends Control

# Emitted when the notepad button was pressed
signal notepad_pressed

# Emitted when the menu button was pressed (on touch devices)
signal menu_pressed


# Emitted, when another inventory item was triggered
signal triggered_inventory_item(first_item, second_item)


# The currently selected inventory item or null
var selected_item: InventoryItemNode = null

# Wether the inventory is currently activated
var activated: bool = false

# Wether the inventory item was just released (to prevent other
# actions to be carried out)
var just_released: bool = false


# The list of inventory items
var _inventory_items: Array


# Helper variable if we're on a touch device
var is_touch: bool


# Hide the activate and menu button on touch devices
func _ready():
	is_touch = OS.has_touchscreen_ui_hint()
	if is_touch:
		$Canvas/InventoryAnchor/Activate.show()
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.show()
	else:
		$Canvas/InventoryAnchor/Activate.hide()
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.hide()


func _process(_delta):
	just_released = false


# Handle inventory drop events and border trigger for mouse
func _input(event):
	if not DetailView.is_visible:
		# Drop the inventory item on RMB and two finger touch
		if Inventory.selected_item != null and \
				 event is InputEventMouseButton and \
				(event as InputEventMouseButton).button_index == BUTTON_RIGHT \
				and not (event as InputEventMouseButton).pressed:
			release_item()
			just_released = true
		elif Inventory.selected_item != null and \
				event is InputEventScreenTouch and \
				(event as InputEventScreenTouch).index == 2 and \
				not (event as InputEventScreenTouch).pressed:
			release_item()
			just_released = true
		elif ! is_touch and event is InputEventMouseMotion and \
				$Timer.is_stopped():
			# Activate the inventory when reaching the upper screen border
			if ! activated and get_viewport().get_mouse_position().y <= 10:
				toggle_inventory()
			# Deactivate the inventory when the mouse is below it
			elif activated and \
					get_viewport().get_mouse_position().y \
					> $Canvas/InventoryAnchor/Panel.rect_size.y:
				toggle_inventory()


# Configure the inventory. Should be call by a game core singleton
func configure(configuration: GameConfiguration):
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.texture_normal = \
			configuration.inventory_texture_menu
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Notepad.texture_normal = \
			configuration.inventory_texture_notepad
	$Canvas/InventoryAnchor.theme = configuration.design_theme
	$Canvas/InventoryAnchor/Panel.rect_min_size.y = configuration.inventory_size
	$Canvas/InventoryAnchor/Panel.add_stylebox_override(
		"panel",
		$Canvas/InventoryAnchor/Panel.get_stylebox("inventory_panel", "Panel")
	)
	
	$Canvas/InventoryAnchor/Activate.texture_normal = \
		configuration.inventory_texture_activate
	$Canvas/InventoryAnchor/Activate.margin_top = \
			configuration.inventory_size + 20
		
	$Canvas/InventoryAnchor.margin_top = configuration.inventory_size * -1
	
	var animation: Animation = $Animations.get_animation("Activate")
	animation.track_set_key_value(
		0,
		0,
		configuration.inventory_size * -1
	)
	
	DetailView.get_node("Panel").theme = configuration.design_theme


# Disable the inventory system
func disable():
	$Canvas/InventoryAnchor/Panel.hide()
	$Canvas/InventoryAnchor/Activate.hide()


# Enable the inventory system
func enable():
	$Canvas/InventoryAnchor/Panel.show()
	if is_touch:
		print_debug("Enabling activate again")
		$Canvas/InventoryAnchor/Activate.show()


# Add an item to the inventory
func add_item(item: InventoryItem, skip_show: bool = false):
	var inventory_item_node = InventoryItemNode.new()
	inventory_item_node.configure(item)
	inventory_item_node.connect(
		"triggered_inventory_item",
		self,
		"_on_triggered_inventory_item"
	)
	_inventory_items.append(inventory_item_node)
	_update()
	if not activated and not skip_show:
		# Briefly show the inventory when it is not activated
		toggle_inventory()
		$Timer.start()
		yield($Timer,"timeout")
		$Timer.stop()
		toggle_inventory()


# Remove item from the inventory
func remove_item(item: InventoryItem):
	var found_index = -1
	for index in range(_inventory_items.size()):
		if (_inventory_items[index] as InventoryItemNode).item == item:
			found_index = index
	if found_index != -1:
		if selected_item == _inventory_items[found_index]:
			release_item()
		_inventory_items.remove(found_index)
		_update()


# Release the currently selected item
func release_item():
	selected_item.texture_normal = \
			(selected_item.item as InventoryItem).image_normal
	selected_item.modulate.a = 1
	selected_item = null
	if not is_touch:
		Cursors.reset(Cursors.Type.DEFAULT)
		Speedy.keep_shape = false


# Returns the current list of inventory items
func get_items() -> Array:
	var items = [] 
	for item in _inventory_items:
		items.append(item.item)
	return items


# Show or hide the inventory
func toggle_inventory():
	if activated:
		$Animations.play_backwards("Activate")
		activated = false
	else:
		$Animations.play("Activate")
		activated = true


# Activate the inventory (on touch devices)
func _on_Activate_pressed():
	toggle_inventory()


# Emit signal, that the notepad was pressed
func _on_Notepad_pressed():
	if selected_item == null:
		emit_signal("notepad_pressed")
		accept_event()


# Emit signal, that the menu was pressed
func _on_Menu_pressed():
	emit_signal("menu_pressed")
	accept_event()


# Emit a signal, that one item was triggered on another item	
func _on_triggered_inventory_item(
	first_item: InventoryItem,
	second_item: InventoryItem
):
	emit_signal("triggered_inventory_item", first_item, second_item)


# Update the inventory item view by simply removing all items and re-adding them
func _update():
	var inventory_panel = \
			$Canvas/InventoryAnchor/Panel/InventoryPanel/Inventory
	for child in inventory_panel.get_children():
		inventory_panel.remove_child(child)
	for item in _inventory_items:
		inventory_panel.add_child(item)