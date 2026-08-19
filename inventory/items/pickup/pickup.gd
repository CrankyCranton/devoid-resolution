@tool
class_name Pickup extends Area2D


@export var ITEM: PackedScene:
	set(value):
		if ITEM == value:
			return # Save on processing.
		ITEM = value
		if not is_node_ready():
			await ready

		for sprite: Sprite2D in sprites.get_children():
			sprite.queue_free()
		if ITEM != null:
			var state: SceneState = ITEM.get_state()
			for idx: int in state.get_node_count():
				if state.get_node_type(idx) == &"Sprite2D":
					var sprite := Sprite2D.new()
					for prop_idx: int in state.get_node_property_count(idx):
						sprite.set(state.get_node_property_name(idx, prop_idx),
								state.get_node_property_value(idx, prop_idx))
					sprites.add_child(sprite)

# Might want to cache the textures into a static var if it gets too demanding on the CPU.
@onready var sprites: Node2D = $Sprites
