# An inventory item
tool
class_name InventoryItem, \
		"res://addons/mdna_inventory/images/inventory_item.svg"
extends Resource


# The title of the inventory item
export (String) var title: String

# A description for the inventory item
export (String, MULTILINE) var description: String

# The image/mouse pointer for the inventory item
export (Texture) var image_normal: Texture

# The image/mouse pointer for the inventory item if it's selected
export (Texture) var image_active: Texture

# The big image used in detail views
export (Texture) var image_big: Texture

