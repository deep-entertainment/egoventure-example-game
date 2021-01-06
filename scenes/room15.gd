extends Node2D


const CHANGE = 1000.0


var change_x = 0.0


func _process(delta):
	$Camera2D.translate( Vector2(change_x * delta, 0))
	if $Camera2D.position.x > 6540:
		$Camera2D.position.x = 0
	if $Camera2D.position.x < -6540:
		$Camera2D.position.x = 6540
	$CanvasLayer/Label.text = String($Camera2D.position.x)


func _on_Left_mouse_entered():
	change_x = CHANGE * -1


func _on_Left_mouse_exited():
	change_x = 0
	# test


func _on_Right_mouse_entered():
	change_x = CHANGE


func _on_Right_mouse_exited():
	change_x = 0


func _on_Me_pressed():
	Parrot.play(preload("res://dialogs/thatsme.tres"))
