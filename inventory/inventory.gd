class_name Inventory extends Resource
# TODO: Think about if there will be any items like weapons that can't be stacked. If so, handle it.


signal item_created(slot: int, item: PackedScene, count: int)
signal item_deleted(slot: int)
signal items_added(slot: int, count: int)
signal items_subtracted(slot: int, count: int)
signal slots_full

@export var max_slots: int = 16
## Format: [<slot_idx>: [<ItemScene>, <count>]]
@export var items: Dictionary[int, Array]


# Should there be an option for selecting a slot when adding items?
# Because the player may not be able to add items, but only move or remove them.
func add_item(item: PackedScene, count: int = 1) -> void:
	var remaining_slots: PackedInt64Array = range(max_slots)
	for slot: int in items:
		assert(slot < max_slots)
		if items[slot][0] == item:
			_add_items(slot, count)
			return
		else:
			remaining_slots.erase(slot)

	if remaining_slots.size() > 0:
		_create_item(remaining_slots[0], [item, count])
	else:
		slots_full.emit()


func move_item(from_inv: Inventory, from_slot: int, to_slot: int) -> void:
	assert(from_slot < from_inv.max_slots)
	assert(to_slot < max_slots)

	# This code is confusing the way it repeats but doesn't. But IDK how to fix it.
	# WARNING: The code allows for creating multiple stacks of the same item.
	var moving_item: Array = from_inv.items[from_slot]
	if items.has(to_slot):
		if items[to_slot][0] == from_inv.items[from_slot][0]:
			from_inv._delete_item(from_slot)
			_add_items(to_slot, moving_item[1])
		else:
			# NOTE: Performance can be increased by only emitting the item_deleted signal.
			from_inv._delete_item(from_slot)
			from_inv._create_item(from_slot, items[to_slot])

			_delete_item(to_slot)
			_create_item(to_slot, moving_item)
	else:
		from_inv._delete_item(from_slot)
		_create_item(to_slot, moving_item)


func remove_item(slot: int, count: int) -> void:
	assert(slot < max_slots)
	@warning_ignore("standalone_ternary")
	_delete_item(slot) if items[slot][1] <= count else _subtract_items(slot, count)


func _create_item(slot: int, item_info: Array) -> void:
	items[slot] = item_info
	item_created.emit(slot, item_info[0], item_info[1])


func _delete_item(slot: int) -> void:
	items.erase(slot)
	item_deleted.emit(slot)


func _add_items(slot: int, count: int) -> void:
	items[slot][1] += count
	items_added.emit(slot, count)


func _subtract_items(slot: int, count: int) -> void:
	items[slot][1] -= count
	items_subtracted.emit(slot, count)
