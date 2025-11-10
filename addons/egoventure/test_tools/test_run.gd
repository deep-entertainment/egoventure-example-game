# Test Run 
extends Node

# Flags that indicate whether a test script 
# is getting recorded or is running or is paused
var _recording: bool = false
var _running: bool = false
var _paused: bool = false

# Test Script that is running or gets recorded
var test_script: TestScript

# Waiting time between test script steps in seconds
var step_wait_time: float = 0.1

# Step counter
var _step: int = 0

# Flags that gets set while a step is in process
var _step_in_process: bool = false

# Supported actions of the test script
# LEFT_CLICK = Left Mouse Button
# RIGHT_CLICK = Right Mouse Button
# INVENTORY = Show Inventory Bar
enum Action {LEFT_CLICK, RIGHT_CLICK, SHOW_INVENTORY}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	step_wait_time = EgoVenture.in_game_configuration.test_step_wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (
		_running and
		!_step_in_process and
		!get_tree().paused and 
		get_tree().current_scene and
		test_script.steps[_step].scene_name == EgoVenture.current_scene and 
		test_script.steps[_step].mouse_hidden == Speedy.hidden and
		(
			# Only process in multi side rooms when current view fits to test script
			!EgoVenture.current_scene_is_multi_side or 
			test_script.steps[_step].scene_view == EgoVenture.current_view
		)
	):
		# Verify that node exists in current scene and is visible
		if test_script.steps[_step].node_path != "":
			var node = get_tree().current_scene.get_node(test_script.steps[_step].node_path)
			if !node:
				print("node_path %s not found" % test_script.steps[_step].node_path)
				return
			else:
				if !node.visible:
					print("node %s not (yet) visible")
					return
		
		# Execute next test script step
		_step_in_process = true
		print("Next step: %s" % test_script.steps[_step].to_string())

		# If dialog is playing and next action is on node Parrot 
		# wait at least until Parrot DURATION_NO_SKIP has passed
		if Parrot.is_dialog_playing() and test_script.steps[_step].node_path == "/root/Parrot":
			await get_tree().create_timer(Parrot.DURATION_NO_SKIP).timeout

		# Process left click mouse action
		if test_script.steps[_step].action == Action.LEFT_CLICK:
			get_viewport().warp_mouse(test_script.steps[_step].mouse_position)
			get_viewport().update_mouse_cursor_state()
			var click := InputEventMouseButton.new()
			click.position = test_script.steps[_step].mouse_position
			click.set_button_index(MOUSE_BUTTON_LEFT)
			click.set_pressed(true)
			get_viewport().push_input(click, true)
			click = InputEventMouseButton.new()
			click.position = test_script.steps[_step].mouse_position
			click.set_button_index(MOUSE_BUTTON_LEFT)
			click.set_pressed(false)
			get_viewport().push_input(click, true)
		# Process Show Inventory action
		elif test_script.steps[_step].action == Action.SHOW_INVENTORY:
			# Check whether Inventory bar animation is still playing
			if get_node("/root/Inventory/Animations").is_playing():
				# Wait until animation is finished
				await get_tree().create_timer(0.3).timeout
			if !Inventory.activated:
				# Move mouse and show inventory bar
				get_viewport().warp_mouse(test_script.steps[_step].mouse_position)
				get_viewport().update_mouse_cursor_state()
				# Wait a bit whether inventory bar gets activate automatically
				await get_tree().create_timer(0.1).timeout
				# Otherwise activate it directly
				if !Inventory.activated:
					Inventory.toggle_inventory()
				# Wait for 0.3 seconds until inventory bar animation is finished
				await get_tree().create_timer(0.3).timeout
		# Process right click mouse action
		elif test_script.steps[_step].action == Action.RIGHT_CLICK:
			# Supported right click events: release item, inventory detail (open/close)
			# Ignored right click events: jump to menu
			if Inventory.selected_item or Inventory.activated or DetailView.is_visible:
				get_viewport().warp_mouse(test_script.steps[_step].mouse_position)
				get_viewport().update_mouse_cursor_state()
				var click := InputEventMouseButton.new()
				click.position = test_script.steps[_step].mouse_position
				click.set_button_index(MOUSE_BUTTON_RIGHT)
				click.set_pressed(true)
				get_viewport().push_input(click, true)
				click = InputEventMouseButton.new()
				click.position = test_script.steps[_step].mouse_position
				click.set_button_index(MOUSE_BUTTON_RIGHT)
				click.set_pressed(false)
				get_viewport().push_input(click, true)
		else:
			pass
		
		# Move to next test script step
		_step = _step + 1
		# End of test script reached?
		if _step >= test_script.steps.size():
			_running = false
			print("Test script finished")
		
		# Wait for next step
		if step_wait_time > 0:
			await get_tree().create_timer(step_wait_time).timeout
			
		# Allow that next step gets processed
		_step_in_process = false


func start_recording() -> void:
	# start not allowed when a recording is already running or a test run is active
	if _recording or _running:
		return
	test_script = TestScript.new()
	_recording = true
	_running = false
	_paused = false


func finish_recording(path: String) -> void:
	if !_recording or path == "":
		return
	if test_script.save_script(path) == OK:
		_recording = false
		_running = false
		_paused = false	


func get_current_name() -> String:
	var name: String = ""
	if test_script:
		name = test_script.name
	return name


func load_test_script(name) -> void:
	test_script = TestScript.load_script(name)
	if test_script:
		test_script.name = name


func run_test_script() -> void:
	# check whether there's a test script
	if !test_script:
		print("Test Run Error: No test script loaded")
		return
		
	EgoVenture.in_game_configuration.continue_state = test_script.start_state.duplicate()
	# Switch to menu as load_continue expects to be started in main menu only
	MainMenu.disabled = false
	if !get_node("/root/MainMenu/Menu").visible:
		MainMenu.toggle()
	EgoVenture.load_continue()
	_step = 0
	_running = true
	print("Test script %s started" % test_script.name)


func pause_test_script() -> void:
	if _running:
		_running = false
		_paused = true


func resume_test_script() -> void:
	if _paused:
		_running = true
		_paused = false


func stop_test_script() -> void:
	_running = false
	_paused = false


func is_recording() -> bool:
	return _recording


func is_running() -> bool:
	return _running


func is_paused() -> bool:
	return _paused
