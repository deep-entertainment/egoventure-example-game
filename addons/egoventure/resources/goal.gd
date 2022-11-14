# A goal in the notepad hint system
class_name Goal
extends Resource


# The numeric id of this goal
@export var id: int


# The title of the goal
@export var title: String


# A list of hints
@export var hints: Array[String]


# The last hint currently visible
@export var hints_fulfilled: Array[bool]
