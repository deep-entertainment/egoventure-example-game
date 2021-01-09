# Core features for MDNA games
tool
extends EditorPlugin


# Add MdnaCore and the MainMenu as singletons, load the default audio bus
# layout
func _enter_tree():
	add_autoload_singleton(
		'MainMenu', 
		'res://addons/mdna_core/nodes/main_menu.tscn'
	)
	add_autoload_singleton(
		'WaitingScreen',
		'res://addons/mdna_core/nodes/waiting_screen.tscn'
	)
	add_autoload_singleton(
		'Boombox',
		'res://addons/mdna_core/nodes/boombox.tscn'
	)
	add_autoload_singleton(
		'Cursors',
		'res://addons/mdna_core/cursors.gd'
	)
	add_autoload_singleton("MdnaCore", "res://addons/mdna_core/mdna_core.gd")
	AudioServer.set_bus_layout(
		preload("res://addons/mdna_core/default_bus_layout.tres")
	)


# Remove the previously loaded singletons
func _exit_tree():
	remove_autoload_singleton('MdnaCore')
	remove_autoload_singleton('MainMenu')
	remove_autoload_singleton('Boombox')
