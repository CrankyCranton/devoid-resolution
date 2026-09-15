@tool class_name AbstractItem extends Resource
# Extending from resource so that the parameter presets of each item type
# can be set through the editor.


signal count_changed(count: int)

@export var SCENE: PackedScene
@export var icon: Texture2D
@export var max_stack_size: int = -1
@export var count: int = 1: # WARNING: Be sure to copy deep before modifying, or move count to inventory.gd.
	set(value):
		if max_stack_size >= 0 and value > max_stack_size:
			push_error("Exeeds max stack size. Clamping.")
			count = max_stack_size
		else:
			count = value
		count_changed.emit(count)
