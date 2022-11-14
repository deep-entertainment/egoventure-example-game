# A dialog of characters speaking (or a monolog as well)
@tool
class_name DialogResource
extends Resource
@icon("res://addons/parrot/images/dialog.svg")

# The descriptive id of this dialog
var id: String

# A list of dialog lines to speak
@export var lines: Array[DialogLineResource]

