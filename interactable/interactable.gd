class_name Interactable extends Area2D


static var current_interactable: Interactable = null

@export var simultanious_interact := false

var within_range := false

@onready var instructions: Label = $Instructions # TODO: Clamp intruction text to the screen bounds.


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed(&"interact") and within_range
			and (current_interactable == null or simultanious_interact)):
		if not simultanious_interact:
			current_interactable = self
		@warning_ignore("redundant_await")
		await _interact(get_overlapping_bodies()[0])
		if not simultanious_interact:
			current_interactable = null


# Wish I could make the class and this function @abstract,
# but then I wouldn't be able to tie the script to interactable.tscn.
func _interact(_interactor: Player) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	within_range = true
	instructions.show()


func _on_body_exited(_body: Node2D) -> void:
	within_range = false
	instructions.hide()
