# A rolling cache to preload scenes for a better performance
# Uses the ResourceQueue as described in the Godot documentation
class_name SceneCache
extends Node


# All pending resources were loaded
signal queue_complete


# A cache of scenes for faster switching
var _cache: Dictionary

# The regex to cut the scene index from the filename
var _scene_index_regex: RegEx

# Number of scenes to cache before and after the current scene
var _cache_count: int

# Path to scenes
var _scene_path: String

# Resource queue
var _resource_queue: ResourceQueue

# Current items in the cache
var _queued_items: Array = []

# Do not remove these scenes from the cache
var _permanent_cache: PoolStringArray = []

# Cache Map
var _cache_map: CacheMap

# Estimated Cache Size
var _cache_size: int
var _cache_max_size = 51200 # for prototype: set cache max size to 50 MB

# Depth to read from cache map
var _cache_depth = 2

# Inner Class for cache management
class CacheMgmt:
	var age: int
	var size: float
	
	func _init(age, size):
		self.age = age
		self.size = size

var _cache_mgr: Dictionary

var _cache_age: int
var _cache_clear_age: int

# Initialize the cache
#
# ** Parameters **
#
# - cache_count: The number of scenes to cache before and after the 
#   current scene
# - scene_path: The absolute path where scenes are stored
# - scene_regex: A regex to search for the scene index in the scene filename
#   has to include a named group called "index"
func _init(
	cache_count: int, 
	scene_path: String, 
	scene_regex: String,
	permanent_cache: PoolStringArray
):
	_cache_count = cache_count
	_scene_path = scene_path
	_permanent_cache = permanent_cache
	_scene_index_regex = RegEx.new()
	_scene_index_regex.compile(scene_regex)
	_resource_queue = ResourceQueue.new()
	_resource_queue.start()
	
	_cache_size = 0
	if ResourceLoader.exists("res://cache_map.tres"):
		_cache_map = ResourceLoader.load("res://cache_map.tres")
	
	# initialize cache manager
	_cache_age = _cache_depth # starting age is depth of cache
	_cache_clear_age = 0
	_cache_mgr.clear()


# Update the current progress on the waiting screen and emit the queue_complete
# signal when we're done
func update_progress():
	if _queued_items.size() > 0:
		var _still_waiting = 0.0
		for item in _queued_items:
			var progress = _resource_queue.get_progress(item)
			if progress > -1 and progress < 1.0:
				_still_waiting = _still_waiting + 1
			elif progress == 1.0:
				_cache[item] = _resource_queue.get_resource(item)
		var resource_queue_size: float = float(_resource_queue.queue.size())
		var current_progress: float = \
				100 - (_still_waiting / float(_queued_items.size()) * 100.0)
		WaitingScreen.set_progress(current_progress)
		if _still_waiting == 0:
			_queued_items = []
			emit_signal("queue_complete")


# Retrieve a scene from the cache. If the scene wasn't already cached, 
# this function will wait for it to be cached.
#
# ** Parameters **
# 
# - path: The path to the scene
func get_scene(path: String) -> PackedScene:
	if not path in _cache.keys():
		var scene = _resource_queue.get_resource(path)
		_cache[path] = scene
	return _cache[path]


# Update the cache. Start caching new scenes and remove scenes, that
# are not used anymore
#
# ** Parameters **
#
# - current_scene: The path and filename of the current scene
# **Returns** Number of cached scenes
func update_cache(current_scene: String) -> int:
	var scene_list: Dictionary # list of scenes read from cache map: Dictionary value = depth / distance
	var _cache_updated = false
	
	# add current scene to caching
	if !current_scene in _permanent_cache:
		scene_list[current_scene] = 0
		
	# read surrounding scenes to caching
	# note: dictionary 'scene_list' is passed by reference and gets updated
	_read_cache_map(scene_list, current_scene, _cache_depth) 
		
	for mapped_scene in scene_list.keys():
		if not mapped_scene in _cache_mgr.keys():
			if not mapped_scene in _permanent_cache: # mapped scenes in permanent cache don't have to be cached again
				var mapped_scene_size = _cache_map.map[mapped_scene][0]
				while (
					_cache_size + mapped_scene_size > _cache_max_size and
					_cache_age - 1 != _cache_clear_age  # don't clear cache that was loaded in previous step
					):
					print("Current cache size %s + new scene size %s > max cache size %s" % [_cache_size, mapped_scene_size, _cache_max_size])
					print("Remove scenes from cache with age %s" % _cache_clear_age)
					_remove_scenes_from_cache(_cache_clear_age)
					_cache_clear_age += 1
					#print ("Cache Clear Age has been increased to: %s" % _cache_clear_age)
				if _cache_size + mapped_scene_size <= _cache_max_size:
					_cache_size += mapped_scene_size
					_cache_mgr[mapped_scene] = CacheMgmt.new(_cache_age - scene_list[mapped_scene], mapped_scene_size)
					print("Queueing load of mapped scene %s. Age: %s. Cache size: %s." % [mapped_scene.get_file(), _cache_age - scene_list[mapped_scene], _cache_size])
					_resource_queue.queue_resource(mapped_scene)
					_queued_items.append(mapped_scene)
					_cache_updated = true
				else:
					print("Cache size %s kB reached. Scene %s coud not be cached!" % [_cache_max_size, mapped_scene.get_file()])
		else:
			# update age in _cache_manager
			if _cache_mgr[mapped_scene].age != _cache_age - scene_list[mapped_scene]:
				_cache_mgr[mapped_scene].age = _cache_age - scene_list[mapped_scene]
				_cache_updated = true
#				print("Updating age of scene %s to age %s." % [mapped_scene, _cache_age - scene_list[mapped_scene]])
#			else:
#				print("Age of scene %s not changed." % mapped_scene)
	
	if _cache_updated:
		_cache_age += 1
		#print ("Cache Age has been increased to: %s" % _cache_age)
	
	########### TO BE REMOVED IN FINAL VERSION ###########
	# Consistency Check that _cache_size equals the _cache_manager's size
	var calc_size = 0
	for i in _cache_mgr:
		calc_size += _cache_mgr[i].size
	if calc_size != _cache_size:
		printerr("Cache Size differs: Cache Manager size: %s, _cache_size: %s" % [calc_size, _cache_size])
	######################################################
	
	if _queued_items.size() == 0:
		WaitingScreen.hide()
		emit_signal("queue_complete")
	
	return _queued_items.size()


func update_permanent_cache(scene):
	# Directly cache permanent scenes
	_resource_queue.queue_resource(scene)
	_queued_items.append(scene)


func _remove_scenes_from_cache(age_remove):
	var scene_removal: Array
	
	for scene in _cache_mgr:
		if(_cache_mgr[scene].age <= age_remove):
			scene_removal.append(scene)
	
	for scene in scene_removal:
			_cache_size -= _cache_mgr[scene].size
			print_debug("Removing scene %s from cache. Age: %s. New cache size: %s" % [scene, _cache_mgr[scene].age, _cache_size])
			_cache.erase(scene)
			_cache_mgr.erase(scene)


func print_cache_mgr():
	var count = 0
	var sum = 0
	
	print("Scenes in cache:")
	for scene in _cache:
		print("Scene: %s" % scene)
		count += 1
	print("Total scenes in cache: %s" % count)
	
	count = 0
	print("Scenes in cache manager:")
	for scene in _cache_mgr:
		print("Age: %s, Size: %s, Scene: %s" % [_cache_mgr[scene].age, _cache_mgr[scene].size, scene])
		count += 1
		sum += _cache_mgr[scene].size
	print("Total scenes in cache manager: %s, Total cache size: %s" % [count, sum])


# Extract index from filename
#
# ** Parameters **
# 
# filename: The path and filename of the scene
func _get_index_from_filename(filename: String) -> int:
	filename = filename.get_file()
	var result = _scene_index_regex.search(filename)
	if result == null:
		return -1
	return int(result.get_string("index"))


func _read_cache_map(scene_list: Dictionary, current_scene: String, depth: int):
	for surr_scene in _cache_map.map[current_scene][1]:
		if not scene_list.has(surr_scene):
			scene_list[surr_scene] = depth
		if depth > 1:
			_read_cache_map(scene_list, surr_scene, depth - 1)
