# An inventory system for MDNA games
tool
extends EditorPlugin


# Add the inventory as a singeleton
func _enter_tree():
	add_autoload_singleton(
		"MdnaInventory", 
		"res://addons/mdna_inventory/nodes/mdna_inventory.tscn"
	)
	add_autoload_singleton(
		"DetailView",
		"res://addons/mdna_inventory/nodes/detail_view.tscn"
	)
	

# Remove the inventory
func _exit_tree():
	remove_autoload_singleton("MdnaInventory")
	remove_autoload_singleton("DetailView")
