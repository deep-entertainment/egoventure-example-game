# A base state used as a base class in all game states
class_name BaseState
extends Resource


# The path of the currently shown scene
export(String) var current_scene: String

# Current list of inventory items
export(Array) var inventory_items: Array

# Target view of the stored scene
export(String) var target_view: String
