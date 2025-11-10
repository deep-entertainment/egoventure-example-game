class_name TestDialog
extends Window

const SAVE_DIR: String = "user://test_scripts"
var _file_save_mode: bool = false



func show_popup() -> void:
	if TestRun.is_running():
		TestRun.pause_test_script()
	_update_controls()
	popup()
	_show_OS_cursor(true)


func _update_controls() -> void:
	$MarginContainer/VBox/Grid/StepWaitTime.set_value_no_signal(TestRun.step_wait_time)
	$MarginContainer/VBox/Grid/NameTestScript.text = TestRun.get_current_name()
	if TestRun.is_recording():
		$MarginContainer/VBox/VBox/Record.text = "Stop Recording & Save"
		$MarginContainer/VBox/VBox/Load.disabled = true
		$MarginContainer/VBox/VBox/Run.disabled = true
		$MarginContainer/VBox/VBox/Stop.disabled = true
	else:
		$MarginContainer/VBox/VBox/Record.text = "Record new test script"
		$MarginContainer/VBox/VBox/Load.disabled = false
		if TestRun.is_paused():
			$MarginContainer/VBox/VBox/Stop.disabled = false
		else:
			$MarginContainer/VBox/VBox/Stop.disabled = true
		if TestRun.test_script:
			$MarginContainer/VBox/VBox/Run.disabled = false
		else:
			$MarginContainer/VBox/VBox/Run.disabled = true
	set_size(get_contents_minimum_size())
	move_to_center()


func _on_step_wait_time_value_changed(value: float) -> void:
	EgoVenture.in_game_configuration.test_step_wait_time = value
	EgoVenture.save_in_game_configuration()
	TestRun.step_wait_time = value


func _on_run_pressed() -> void:
	_show_OS_cursor(false)
	queue_free()
	TestRun.run_test_script()


func _on_stop_pressed() -> void:
	TestRun.stop_test_script()
	_show_OS_cursor(false)
	queue_free()

func _on_load_pressed() -> void:
	var file_dialog = $FileDialog
	file_dialog.access = FileDialog.ACCESS_USERDATA
	file_dialog.root_subfolder = _set_subfolder()
	file_dialog.clear_filters()
	file_dialog.add_filter("*.tres ; EgoVenture TestScript")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.move_to_center()
	file_dialog.show()
	_file_save_mode = false  # load test script


func _on_record_pressed() -> void:
	if !TestRun.is_recording():
		if get_node("/root/MainMenu/Menu").visible:
			printerr("Test Recording can not be started when main menu is visible")
			return
		_show_OS_cursor(false)
		queue_free()
		TestRun.start_recording()
	else:
		var file_dialog = $FileDialog
		file_dialog.access = FileDialog.ACCESS_USERDATA
		file_dialog.root_subfolder = _set_subfolder()
		file_dialog.clear_filters()
		file_dialog.add_filter("*.tres ; EgoVenture TestScript")
		file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		file_dialog.move_to_center()
		file_dialog.show()
		_file_save_mode = true  # save test script


func _on_file_selected(path: String) -> void:
	if !_file_save_mode:
		TestRun.load_test_script(path)
	else:
		if path:
			TestRun.finish_recording(path)
	_update_controls()


func _set_subfolder() -> String:
	if !DirAccess.dir_exists_absolute(SAVE_DIR):
		if !DirAccess.make_dir_absolute(SAVE_DIR) == OK:
			printerr("Error when creating directory %s" % SAVE_DIR)
			return("user://")
	return(SAVE_DIR)


func _on_close_requested() -> void:
	_show_OS_cursor(false)
	if TestRun.is_paused():
		TestRun.resume_test_script()
	queue_free()


func _show_OS_cursor(flag: bool) -> void:
	if !flag:
		Input.set_mouse_mode(
			Input.MOUSE_MODE_HIDDEN
		)
		Speedy.hidden = false
	else:
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE
		)
		Speedy.hidden = true


func _input(event: InputEvent) -> void:
	if (
		event is InputEventKey and
		(event.is_action_pressed("ui_menu") or event.is_action_pressed("test_dialog"))
	):
		get_viewport().set_input_as_handled()
		_on_close_requested()
		
