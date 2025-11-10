# A base state used as a base class in all game states
class_name BaseState
extends Resource


# The path of the currently shown scene
@export var current_scene: String

# Current list of inventory items
@export var inventory_items: Array

# Target view of the stored scene
@export var target_view: String

# Target location of the stored scene
@export var target_position: String

# Path to current music playing
@export var current_music: Array

# Path to current background playing
@export var current_background: Array

# Current notepad goal
@export var current_goal: int = 1

# An array of FulfillmentRecords
@export var goals_fulfilled: Array

# The currently overridden cursors
@export var overridden_cursors: Dictionary = {}

# Whether skipping in Parrot is enabled
@export var parrot_skip_enabled: bool = true
