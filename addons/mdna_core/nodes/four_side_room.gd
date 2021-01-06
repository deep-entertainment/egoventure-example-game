tool
class_name FourSideRoom
extends Node2D


const VIEW_FRONT = "front"
const VIEW_RIGHT = "right"
const VIEW_BACK = "back"
const VIEW_LEFT = "left"
const VIEW_UNSET = ""


export (String, "front", "right", "back", "left") var default_view = VIEW_FRONT
export (Texture) var front_texture setget _front_texture_set
export (Texture) var right_texture setget _right_texture_set
export (Texture) var back_texture setget _back_texture_set
export (Texture) var left_texture setget _left_texture_set
export (float) var image_scale = 1.0 setget _set_image_scale


var current_view = VIEW_UNSET setget _set_current_view


var _viewport_size


func _init():
	_viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height")
	)


func _ready():
	if not Engine.editor_hint:
		MdnaCore.update_cache()
		if MdnaCore.target_view != VIEW_UNSET:
			_set_current_view(MdnaCore.target_view)
		else:
			_set_current_view(default_view)
		_set_image_scale(
			MdnaCore.configuration.scene_default_image_scaling
		)


func _enter_tree():
	$Views/Front.position = Vector2(0, _viewport_size.y * -1)
	$Views/Right.position = Vector2(_viewport_size.x, 0)
	$Views/Back.position = Vector2(0, _viewport_size.y)
	$Views/Left.position = Vector2(_viewport_size.x * -1, 0)
	_set_image_scale(image_scale)
	
	
func _set_image_scale(value: float):
	if value > 0:
		image_scale = value
		$Views/Front.scale = Vector2(
			image_scale,
			image_scale
		)
		$Views/Right.scale = Vector2(
			image_scale,
			image_scale
		)
		$Views/Back.scale = Vector2(
			image_scale,
			image_scale
		)
		$Views/Left.scale = Vector2(
			image_scale,
			image_scale
		)


func _set_current_view(value: String):
	current_view = value
	match current_view:
		VIEW_FRONT: $Camera.position = Vector2(0, _viewport_size.y * -1)
		VIEW_RIGHT: $Camera.position = Vector2(_viewport_size.x, 0)
		VIEW_BACK: $Camera.position = Vector2(0, _viewport_size.y)
		VIEW_LEFT: $Camera.position = Vector2(_viewport_size.x * -1, 0)


func _on_right_pressed():
	match current_view:
		VIEW_FRONT: _set_current_view(VIEW_RIGHT)
		VIEW_RIGHT: _set_current_view(VIEW_BACK)
		VIEW_BACK: _set_current_view(VIEW_LEFT)
		VIEW_LEFT: _set_current_view(VIEW_FRONT)


func _on_left_pressed():
	match current_view:
		VIEW_FRONT: _set_current_view(VIEW_LEFT)
		VIEW_LEFT: _set_current_view(VIEW_BACK)
		VIEW_BACK: _set_current_view(VIEW_RIGHT)
		VIEW_RIGHT: _set_current_view(VIEW_FRONT)


func _front_texture_set(value: Texture):
	front_texture = value
	$Views/Front.texture = front_texture
	
	
func _right_texture_set(value: Texture):
	right_texture = value
	$Views/Right.texture = right_texture
	
	
func _back_texture_set(value: Texture):
	back_texture = value
	$Views/Back.texture = back_texture
	
	
func _left_texture_set(value: Texture):
	left_texture = value
	$Views/Left.texture = left_texture
