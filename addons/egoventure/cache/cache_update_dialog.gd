tool
class_name CacheUpdateDialog
extends Control


var _scene_list: Array
var _cache_map = CacheMap.new()

# Show the import source dialog to get started
func show_popup():
	_scene_list = _read_scene_list("res://scenes")
	$CacheUpdateDialog/VBox/SceneCount.text = "This project contains %s scenes." % _scene_list.size()
	$CacheUpdateDialog/VBox/ProgressBar.value = 0.0
	$CacheUpdateDialog.popup_centered()


func _on_Run_pressed():
	var verbose = $CacheUpdateDialog/VBox/HBoxContainer/Verbose.pressed
	var scene_index = 0
	_cache_map.map.clear()
	
	yield(get_tree(),"idle_frame")
	for scene_name in _scene_list:
		
		var scan_result = [0, [] ]
		var linked_scenes = []
		
		scene_index += 1
		var scene = ResourceLoader.load(scene_name)
		if scene.is_class("PackedScene"):
			var scene_node = scene.instance()
			if verbose:
				print("\nScan scene " + scene_name)
			scan_result = _scan_scene(scene_node)
			if verbose:
				print("->" + String(scan_result))
		_cache_map.map[scene_name] = scan_result

		$CacheUpdateDialog/VBox/ProgressBar.set_value(float(scene_index) / _scene_list.size() * 100)
		yield(get_tree(),"idle_frame")
	
	var err = ResourceSaver.save("res://cache_map.tres", _cache_map)
	if err:
		printerr("Saving res://cache_map.tres failed. Error Code %s." % err)
	else:
		print("CacheMap successfully saved in res://cache_map.tres.")
	
	$CacheUpdateDialog.hide()


func _on_Cancel_pressed():
	$CacheUpdateDialog.hide()


func _read_scene_list(path: String) -> Array:
	var file_list: Array
	var dir = Directory.new()
	
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	while file != "":
		if !dir.current_is_dir():
			if file.match("*.tscn"):
				file_list.append(dir.get_current_dir() + "/" + file)
		else:
			file_list.append_array(_read_scene_list(dir.get_current_dir() + "/" + file))
		file = dir.get_next()
	dir.list_dir_end()
	return file_list


# This will scan the scene and will return a size estimate
# and the adjacent scenes
# Array[0]: size estimate, Array[1]: array of adjacent scenes
func _scan_scene(scene_node) -> Array:
	var size_estimate = 0
	var linked_scenes: Array
	var file = File.new()
	
	# Regular expression to select all comments in script
	# The capturing groups are used to ensure that '#' in quotations are not excluded
	# Capturing group 1: all strings surrounded by double quotes
	# Capturing group 3: all strings surrounded by single quotes
	var regex_comment = RegEx.new()
	regex_comment.compile("#.*|(\"(#.|[^\"])*\")|(\'(#.|[^\'])*\')")
	
	# Regular expression for scene resources
	var regex_scene = RegEx.new()
	regex_scene.compile("res:\\/\\/[\\w\\/]*.tscn")
	
	# get all sprites and target scenes listed in nodes
	for node in _get_all_children(scene_node):
		
		if node.get_class() == "Sprite" and node.texture != null:
			if ResourceLoader.exists(node.texture.resource_path):
				file.open(node.texture.resource_path, File.READ)
				var size = file.get_len()
				file.close()
				size_estimate += size
		
		if node.get_class() == "TextureButton" and "target_scene" in node:
			var scene_path = node.target_scene
			if (
				scene_path != "" 
				and ResourceLoader.exists(scene_path)
			):
				linked_scenes.append(scene_path)
	
	# remove comments from source code
	var scene_script = scene_node.get_script()
	var source_code: String
	
	if scene_script and scene_script.has_source_code():
		source_code = scene_script.source_code
		var regex_matches = regex_comment.search_all(source_code)
		for i in range(regex_matches.size() - 1, -1, -1):
			# replace regex match only if group 1 and 3 are empty
			if regex_matches[i].strings[1] == "" and regex_matches[i].strings[3] == "":
				source_code = source_code.substr(0, regex_matches[i].get_start()) + source_code.substr(regex_matches[i].get_end(), -1)

		# scan remaining source code for scene names
		var scene_matches = regex_scene.search_all(source_code)
		for scene in scene_matches:
			var scene_path = scene.get_string()
			if ResourceLoader.exists(scene_path) and not scene_path in linked_scenes:
				linked_scenes.append(scene_path)
	
	# convert size from Byte to kiloByte
	size_estimate = size_estimate / 1024
	
	return [size_estimate, linked_scenes]


func _get_all_children(node:Node)->Array:
	var nodes: Array
	for child in node.get_children():
		nodes.append(child)
		if child.get_child_count() > 0:
			nodes.append_array(_get_all_children(child))
	return nodes

