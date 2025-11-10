# A resource describing a test script
class_name TestScript
extends Resource

@export var start_state: BaseState
# An array of test script items / test steps
@export var steps: Array[TestScriptStep]

var name: String
var current_step: int = -1


func _init() -> void:
	start_state = EgoVenture.get_state()
	steps.clear()


# Adds a new test script step
func add_step(scene_name: String, scene_view: String, action: int,
		mouse_position: Vector2, mouse_hidden: bool,
		item_title: String = "",
		node_type: String = "", node_path: String = ""):
	var step = TestScriptStep.new()
	step.scene_name = scene_name
	step.scene_view = scene_view
	step.action = action
	step.mouse_position = mouse_position
	step.mouse_hidden = mouse_hidden
	step.item_title = item_title
	step.node_type = node_type
	step.node_path = node_path
	steps.append(step)
	current_step = steps.size() - 1


# Adds node information to the current test script step
func set_node_info(node_type: String = "", node_path: String = "") -> void:
	steps[current_step].node_type = node_type
	steps[current_step].node_path = node_path


func write_script() -> void:
	for step in steps:
		print("run.add(\"%s\", \"%s\", %d, Vector2(%d, %d),  %s,\"%s\", \"%s\", \"%s\")" %
			[step.scene_name, step.scene_view, step.action,
			step.mouse_position.x, step.mouse_position.y, step.mouse_hidden,
			step.item_title, step.node_type, step.node_path])


func save_script(path: String) -> Error:
	var err: Error = ResourceSaver.save(
		self,
		path, 
		ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)
	if err == OK:
		name = path
	else:
		printerr("Error when saving test script %s" % path)
		name = ""
	return err


static func load_script(path: String) -> TestScript:
	var steps: TestScript = ResourceLoader.load(
		path,
		"",
		ResourceLoader.CACHE_MODE_IGNORE
	)
	return steps
