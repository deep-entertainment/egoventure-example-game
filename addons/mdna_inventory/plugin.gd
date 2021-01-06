# An inventory system for MDNA games
tool
extends EditorPlugin


# Add the inventory as a singeleton
func _enter_tree():
	add_autoload_singleton(
		"MdnaInventory", 
		"res://addons/mdna_inventory/nodes/mdna_inventory.tscn"
	)
	

# Remove the inventory
func _exit_tree():
	remove_autoload_singleton("MdnaInventory")
