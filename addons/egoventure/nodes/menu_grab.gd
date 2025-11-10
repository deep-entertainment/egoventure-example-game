# A layer that is supposed to grab right mouse button clicks
# to show the menu
extends CanvasLayer

# Flag that gets set when next mouse button release event has to be ignored when recording
var _ignore_next_event: bool = false 


# Set the top margin to under the inventory bar
func set_top(top: float):
	$Control.offset_top = top


# React to mouse button events on the control
func _input(event):
	# Begin of section for test script recording
	if EgoVenture.is_test_run_enabled() and TestRun.is_recording():
		if event is InputEventMouseButton and event.is_pressed():
			# Record Detail View mouse close events (pressed button)
			if DetailView.is_visible:
				TestRun.test_script.add_step(EgoVenture.current_scene, "",
					event.button_index - 1, get_viewport().get_mouse_position(),
					Speedy.hidden, "")
				# The next button release event has to be ignored
				_ignore_next_event = true
		
		# Record left and right mouse click events (released button)
		if event is InputEventMouseButton and !event.pressed:
			# Ignore mouse button event if flag was set
			if _ignore_next_event:
				_ignore_next_event = false
			else:
				var item_title = ""
				var current_view= ""
				if EgoVenture.current_scene_is_multi_side:
					current_view = EgoVenture.current_view
				
				if Inventory.activated:
					# Click event was done with activated Inventory bar, add Show Inventory action
					TestRun.test_script.add_step(EgoVenture.current_scene, current_view, 
						TestRun.Action.SHOW_INVENTORY, get_viewport().get_mouse_position(),
						Speedy.hidden, "")
				
				if Inventory.selected_item:
					# Set selected inventory object
					item_title = Inventory.selected_item.item.title
					
				# Add click event to test script
				TestRun.test_script.add_step(EgoVenture.current_scene, current_view,
					event.button_index - 1, get_viewport().get_mouse_position(),
					Speedy.hidden, item_title)
	# End of section for test script recording
	
	# Display Test Dialog
	if event is InputEventKey and event.is_action_pressed("test_dialog"):
		get_viewport().set_input_as_handled()
		var dialog := preload("res://addons/egoventure/test_tools/test_dialog.tscn").instantiate()
		add_child(dialog)
		dialog.show_popup()
	
	# Check whether main menu gets toggled
	if Inventory.selected_item == null and \
			not WaitingScreen.is_displayed() and \
			not DetailView.is_visible and \
			event.is_action_pressed("ui_menu"):
		if not get_tree().paused and \
			get_viewport().get_mouse_position().y >= $Control.offset_top:
			get_viewport().set_input_as_handled()
			MainMenu.toggle()
		elif get_tree().paused:
			MainMenu.process_ui_menu_event()
