# Parrot - a simple dialogue plugin
@tool
extends EditorPlugin


# The importer scene
var _importer: Importer

# The exporter scene
var _exporter: Exporter


# Add the ParrotDialog scene singleton and the import menu button
func _enter_tree():
	add_autoload_singleton(
		"Parrot", 
		"res://addons/parrot/nodes/parrot_dialog.tscn"
	)
	add_tool_menu_item("Import Dialog", _on_import_menu_clicked)
	_importer = preload("res://addons/parrot/nodes/importer.tscn").instantiate()
	add_child(_importer)
	add_tool_menu_item("Export Dialog", _on_export_menu_clicked)
	_exporter = Exporter.new()
	get_editor_interface().get_editor_main_screen().add_child(_exporter)


# remove_at the singleton and the import menu button
func _exit_tree():
	remove_autoload_singleton("Parrot")
	remove_tool_menu_item("Import Dialog")
	remove_tool_menu_item("Export Dialog")
	remove_child(_importer)
	remove_child(_exporter)


# Show the importer checked the tool menu
func _on_import_menu_clicked(_ud):
	_importer.start_import()
	

# Show the exporter checked the tool menu
func _on_export_menu_clicked(_ud):
	_exporter.start_export()
