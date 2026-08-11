class_name Level extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().reload_current_scene()
