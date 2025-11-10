@tool
# A dialog of characters speaking (or a monolog as well)
@icon("res://addons/parrot/images/dialog.svg")
class_name DialogResource
extends Resource


# The descriptive id of this dialog
var id: String

# A list of dialog lines to speak
@export var lines: Array # (Array, Resource)
