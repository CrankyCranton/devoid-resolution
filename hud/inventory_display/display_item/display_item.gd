class_name DisplayItem extends TextureButton


const DROP_RADIUS: float = pow(32.0, 2.0)

var drag_start := Vector2.INF
var count: int:
	set(value):
		count = value
		count_hud.text = str(value)
var item: AbstractItem:
	set(value):
		item = value
		texture_normal = item.icon
		if item.max_stack_size != 1:
			count = item.count
			item.count_changed.connect(func(count: int) -> void: self.count = count)

@onready var count_hud: Label = $CountHUD


func _process(_delta: float) -> void:
	if drag_start != Vector2.INF:
		offset_transform_position = get_global_mouse_position() - drag_start


func _on_button_down() -> void:
	drag_start = get_global_mouse_position() - offset_transform_position


func _on_button_up() -> void:
	var current_slot: DisplaySlot = null
	var current_dist: float = INF
	for inventory_display_slot: DisplaySlot in get_tree().get_nodes_in_group(&"slots"):
		var pos: Vector2 = global_position
		var dist: float = pos.distance_squared_to(inventory_display_slot.global_position)
		if dist <= DROP_RADIUS and dist < current_dist:
			current_slot = inventory_display_slot
			current_dist = dist

	# Assumes the parent is always the slot this display item is in.
	var from_slot: DisplaySlot = get_parent()
	if current_slot != null:
		#assert(current_slot != from_slot)
		current_slot.inventory.move_item(from_slot.inventory, from_slot.index, current_slot.index)
		reparent(current_slot, false)
	else:
		from_slot.inventory.drop_item(from_slot.index, item.count,
				get_tree().current_scene, global_position)

	offset_transform_position = Vector2.ZERO
	drag_start = Vector2.INF
