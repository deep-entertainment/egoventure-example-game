# A rolling cache to preload scenes for a better performance
# Uses the ResourceQueue as described in the Godot documentation
class_name SceneCache
extends Node


# All pending resources were loaded
signal queue_complete


# A cache of scenes for faster switching
var _cache: Dictionary

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

# Cache map
var _cache_map: CacheMap

# Cache sizes (in kilobyte) - current and maximum
var _cache_size: int
var _cache_max_size: int

# Inner class for parameters of cached scenes
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
#   has to include a named group called "index"
# - permanent_cache: A list of scenes that is cached permanently
# - cache_max_size: Maximum size of cache (w/o permanent cache) in megabyte
func _init(
	cache_count: int, 
	scene_path: String, 
	permanent_cache: PoolStringArray,
	cache_max_size: int
):
	_cache_count = cache_count
	_scene_path = scene_path
	_permanent_cache = permanent_cache
	_resource_queue = ResourceQueue.new()
	_resource_queue.start()
	
	_cache_max_size = cache_max_size * 1024 # MB -> kB
	_cache_size = 0
	
	if ResourceLoader.exists("res://cache_map.tres"):
		_cache_map = ResourceLoader.load("res://cache_map.tres")
	
	# initialize cache manager
	_cache_age = _cache_count # starting age is depth of cache
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
	var scene_list: Dictionary # list of scenes read from cache map
	var _cache_updated = false
	
	# add current scene to caching
	if !current_scene in _permanent_cache:
		scene_list[current_scene] = 0
		
	# read surrounding scenes to caching
	# note: dictionary 'scene_list' is passed by reference and gets updated
	_read_cache_map(scene_list, current_scene, _cache_count) 
		
	for mapped_scene in scene_list.keys():
		if not mapped_scene in _cache_mgr.keys():
			if not mapped_scene in _permanent_cache: # mapped scenes in permanent cache don't have to be cached again
				var mapped_scene_size = _cache_map.map[mapped_scene][0]
				while (
					_cache_size + mapped_scene_size > _cache_max_size and
					_cache_age - 1 != _cache_clear_age  # don't clear cache that was loaded in previous step
					):
					if OS.is_debug_build():
						print("Current cache size %s + new scene size %s > max cache size %s" %
							[_cache_size, mapped_scene_size, _cache_max_size])
						print("Remove scenes from cache with age %s" % _cache_clear_age)
					_remove_scenes_from_cache(_cache_clear_age)
					_cache_clear_age += 1
				
				if _cache_size + mapped_scene_size <= _cache_max_size:
					_cache_size += mapped_scene_size
					_cache_mgr[mapped_scene] = \
						CacheMgmt.new(_cache_age - scene_list[mapped_scene], mapped_scene_size)
					if OS.is_debug_build():
						print("Queueing load of mapped scene %s. Age: %s. Cache size: %s." %
							[mapped_scene.get_file(), _cache_age - scene_list[mapped_scene], _cache_size])
					_resource_queue.queue_resource(mapped_scene)
					_queued_items.append(mapped_scene)
					_cache_updated = true
				else:
					if OS.is_debug_build():
						print("Cache size %s kB reached. Scene %s could not be cached!" %
							[_cache_max_size, mapped_scene.get_file()])
		else:
			# update age in cache manager
			if _cache_mgr[mapped_scene].age != _cache_age - scene_list[mapped_scene]:
				_cache_mgr[mapped_scene].age = _cache_age - scene_list[mapped_scene]
				_cache_updated = true
	
	if _cache_updated:
		_cache_age += 1
	
	if _queued_items.size() == 0:
		WaitingScreen.hide()
		emit_signal("queue_complete")
	
	return _queued_items.size()


# Add a permanent scene to the cache
# Permanent scenes are not handled by cache manager
#
# ** Parameters **
#
# - scene: scene that is to be added to permanent cache
func update_permanent_cache(scene):
	_resource_queue.queue_resource(scene)
	_queued_items.append(scene)


# Remove scenes from cache
#
# ** Parameters **
#
# - age_remove: all scenes up to this age get removed
func _remove_scenes_from_cache(age_remove):
	var scene_removal: Array
	
	for scene in _cache_mgr:
		if(_cache_mgr[scene].age <= age_remove):
			scene_removal.append(scene)
	
	for scene in scene_removal:
			_cache_size -= _cache_mgr[scene].size
			if OS.is_debug_build():
				print("Removing scene %s from cache. Age: %s. New cache size: %s" %
					[scene, _cache_mgr[scene].age, _cache_size])
			_cache.erase(scene)
			_cache_mgr.erase(scene)


# Print content of cache and cache manager to output
# (for cache verification)
func print_cache_mgr():
	var count = 0
	var sum = 0
	
	print("Scenes in cache:")
	for scene in _cache:
		print("Scene: %s" % scene)
		count += 1
	print("Total scenes in cache: %s" % count)
	
	count = 0
	print("\nScenes in cache manager:")
	for scene in _cache_mgr:
		print("Age: %s, Size: %s, Scene: %s" % [_cache_mgr[scene].age, _cache_mgr[scene].size, scene])
		count += 1
		sum += _cache_mgr[scene].size
	print("Total scenes in cache manager: %s, Total cache size: %s" % [count, sum])


# Retrieve scene list from cache map for scene
#
# ** Parameters **
#
# - scene_list: list of scenes including index information
#               passed by reference, parameter gets updated
# - scene: scene for which cache map is read
# - index: recursion index decreasing from scene_count to 1
func _read_cache_map(scene_list: Dictionary, scene: String, index: int):
	for surr_scene in _cache_map.map[scene][1]:
		if not scene_list.has(surr_scene):
			scene_list[surr_scene] = index
		if index > 1:
			_read_cache_map(scene_list, surr_scene, index - 1)
