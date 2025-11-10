# taken from https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html#using-multiple-threads
class_name ResourceQueue
var thread
var mutex
var sem

# maximum and current count of loading threads
const MAX_LOADING_THREADS = 2
var _count_loading_threads = 0

var queue = []
var pending = {}


func _lock(_caller):
	mutex.lock()


func _unlock(_caller):
	mutex.unlock()


func _post(_caller):
	sem.post()


func _wait(_caller):
	sem.wait()


func queue_resource(path, p_in_front = false):
	_lock("queue_resource")
	if path in pending:
		_unlock("queue_resource")
		return
	elif ResourceLoader.has_cached(path):
		var res = ResourceLoader.load(path)
		pending[path] = res
		_unlock("queue_resource")
		return
	else:
		if p_in_front:
			queue.insert(0, path)
		else:
			queue.push_back(path)
		# NOTE: pending[path] is a link to the ResourceInteractiveLoader in Godot 3, not needed in Godot 4
		pending[path] = null 
		_post("queue_resource")
		_unlock("queue_resource")
		return


func cancel_resource(path):
	_lock("cancel_resource")
	if path in pending:
		if pending[path] == null:
			queue.erase(pending[path])
		pending.erase(path)
	_unlock("cancel_resource")


func get_progress(path):
	_lock("get_progress")
	var ret = -1
	if path in pending:
		if pending[path] == null:
			ret = 0.0
		else:
			ret = 1.0
	_unlock("get_progress")
	return ret


func is_ready(path):
	var ret
	_lock("is_ready")
	if path in pending:
		ret = !(pending[path] == null)
	else:
		ret = false
	_unlock("is_ready")
	return ret


func get_resource(path):
	_lock("get_resource")
	if path in pending:
		if pending[path] == null:
			if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				# loading not yet started, start it
				ResourceLoader.load_threaded_request(path)
			# loading started, wait until resource is loaded
			var res = ResourceLoader.load_threaded_get(path)
			_count_loading_threads -= 1
			queue.erase(path)
			pending.erase(path)
			_unlock("return")
			return res
		else:
			var res = pending[path]
			pending.erase(path)
			_unlock("return")
			return res
	else:
		_unlock("return")
		return ResourceLoader.load(path)


func thread_process():
	_wait("thread_process")
	_lock("process")

	while queue.size() > 0:
		var res = queue[0]
		_unlock("process_poll")
		var status = ResourceLoader.load_threaded_get_status(res)
		_lock("process_check_queue")

		if status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			# start loading if maximum number of threads haven't been reached
			if _count_loading_threads < MAX_LOADING_THREADS:
				ResourceLoader.load_threaded_request(res)
				_count_loading_threads += 1
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			var path = res
			if res in pending: # Else, it was already retrieved.
				pending[res] = ResourceLoader.load_threaded_get(res)
				_count_loading_threads -= 1
			# Something might have been put at the front of the queue while
			# we polled, so use erase instead of remove.
			queue.erase(res)
	_unlock("process")


func thread_func(_u):
	while true:
		thread_process()


func start():
	mutex = Mutex.new()
	sem = Semaphore.new()
	thread = Thread.new()
	thread.start(Callable(self, "thread_func").bind(0))
