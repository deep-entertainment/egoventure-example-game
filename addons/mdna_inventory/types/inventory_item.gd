# An inventory item
tool
class_name InventoryItem, \
		"res://addons/mdna_inventory/images/inventory_item.svg"
extends Resource


# The title of the inventory item
var title: String

# A description for the inventory item
var description: String

# The image/mouse pointer for the inventory item
var image_normal: Texture

# The image/mouse pointer for the inventory item if it's selected
var image_active: Texture


# Get properties
func _get_property_list():
	var properties = []
	properties.append({
		"name": "title",
		"type": TYPE_STRING
	})
	properties.append({
		"name": "description",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_MULTILINE_TEXT
	})
	properties.append({
		"name": "image_normal",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		"name": "image_active",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	return properties
