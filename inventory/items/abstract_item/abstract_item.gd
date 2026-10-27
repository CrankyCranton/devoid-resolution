@tool class_name AbstractItem extends Resource
# Extending from resource so that the parameter presets of each item type
# can be set through the editor.


signal count_changed(count: int)

# Should try to avoid using this if possible, in favour of a more elegant local-scoped system.
static var scene_to_item_lookup: Dictionary[PackedScene, AbstractItem]

@export var SCENE: PackedScene
@export var icon: Texture2D
@export var stackable := true
@export var weight: float = 1.0:
	get:
		return weight * count
# WARNING: Be sure to deep copy before modifying, or move count to inventory.gd.
@export var count: int = 1:
	set(value):
		if stackable:
			count = value
			count_changed.emit(count)
		else:
			count = 1


func _init() -> void:
	if not scene_to_item_lookup.has(SCENE):
		scene_to_item_lookup[SCENE] = self
