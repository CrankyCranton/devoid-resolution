class_name Interactable extends Area2D


static var current_interactable: Interactable = null

var within_range := false

@onready var instructions: Label = $Instructions # TODO: Clamp intruction text to within the screen.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact") and within_range and current_interactable == null:
		current_interactable = self
		# await start_dialogue()
		current_interactable = null


func _on_body_entered(_body: Node2D) -> void:
	within_range = true
	instructions.show()


func _on_body_exited(_body: Node2D) -> void:
	within_range = false
	instructions.hide()
