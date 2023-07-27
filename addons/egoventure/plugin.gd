# First person point and click adventure framework for Godot
tool
extends EditorPlugin


var _cache_update_dialog: CacheUpdateDialog

# Add the required singletons, load the default audio bus
# layout
func _enter_tree():
	add_autoload_singleton(
		'MainMenu', 
		'res://addons/egoventure/nodes/main_menu.tscn'
	)
	add_autoload_singleton(
		'WaitingScreen',
		'res://addons/egoventure/nodes/waiting_screen.tscn'
	)
	add_autoload_singleton(
		'Boombox',
		'res://addons/egoventure/nodes/boombox.tscn'
	)
	add_autoload_singleton(
		'Cursors',
		'res://addons/egoventure/types/cursors.gd'
	)
	add_autoload_singleton(
		"EgoVenture", 
		"res://addons/egoventure/egoventure.gd"
	)
	add_autoload_singleton(
		"Notepad", 
		"res://addons/egoventure/nodes/notepad.tscn"
	)
	add_autoload_singleton(
		"MapNotification",
		"res://addons/egoventure/nodes/map_notification.gd"
	)
	add_autoload_singleton(
		"Notification",
		"res://addons/egoventure/nodes/notification.tscn"
	)
	add_autoload_singleton(
		"MenuGrab",
		"res://addons/egoventure/nodes/menu_grab.tscn"
	)	
	add_autoload_singleton(
		"Inventory", 
		"res://addons/egoventure/nodes/inventory/inventory.tscn"
	)
	add_autoload_singleton(
		"DetailView",
		"res://addons/egoventure/nodes/inventory/detail_view.tscn"
	)
	add_autoload_singleton(
		"CheckCursor",
		"res://addons/egoventure/nodes/check_cursor.tscn"
	)
	
	add_tool_menu_item("Update Cache Map", self, "_on_cache_update_menu_clicked")
	_cache_update_dialog = preload("res://addons/egoventure/cache/cache_update_dialog.tscn").instance()
	add_child(_cache_update_dialog)


# Remove the previously loaded singletons
func _exit_tree():
	remove_autoload_singleton('EgoVenture')
	remove_autoload_singleton('MainMenu')
	remove_autoload_singleton('Boombox')
	remove_autoload_singleton('Notepad')
	remove_autoload_singleton('MapNotification')
	remove_autoload_singleton('Inventory')
	remove_autoload_singleton('DetailView')
	remove_autoload_singleton('CheckCursor')
	remove_tool_menu_item("Update Cache Map")
	remove_child(_cache_update_dialog)


func _on_cache_update_menu_clicked(_ud):
	_cache_update_dialog.show_popup()
