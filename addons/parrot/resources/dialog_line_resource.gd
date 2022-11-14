# A resource describing one line in a dialogue
@tool
class_name DialogLineResource
extends Resource
@icon("res://addons/parrot/images/dialog_line.svg")


# The character speaking
@export var character: CharacterResource


# The text the character says
@export var text: String


# An image that is displayed full screen while the line is shown
@export var image: Texture2D
