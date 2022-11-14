# An inventory item
@tool
class_name InventoryItem
extends Resource
@icon("res://addons/egoventure/images/inventory_item.svg")

# The title of the inventory item
@export var title: String

# A description for the inventory item
@export var description: String

# The image/mouse pointer for the inventory item
@export var image_normal: Texture2D

# The image/mouse pointer for the inventory item if it's selected
@export var image_active: Texture2D

# The big image used in detail views
@export var image_big: Texture2D

# The items this item can be combined with
@export var combineable_with: Array # (Array, Resource)

# A scene to load for the detail view instead of the big image
@export var detail_scene: String = ""

# Whether to show the mouse cursor in the detail view
@export var detail_show_mouse: bool = false

# Whether the item is selectable and useable checked the screen
# If set to false, clicking the item with either mouse button will show the
# (custom) detail view
@export var grabbable: bool = true
