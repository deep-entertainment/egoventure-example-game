@tool
# A resource describing one line in a dialogue
@icon("res://addons/parrot/images/dialog_line.svg")
class_name DialogLineResource
extends Resource


# The character speaking
@export var character: Resource


# The text the character says
@export_multiline var text: String


# An image that is displayed full screen while the line is shown
@export var image: Texture2D
