class_name Inventory extends Resource


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
			items[slot][1] += count
			remaining_slots = []
			break
		else:
			remaining_slots.erase(slot)

	if remaining_slots.size() > 0:
		items[remaining_slots[0]] = [item, count]


func move_item(from_inv: Inventory, from_slot: int, to_slot: int) -> void:
	assert(from_slot < from_inv.max_slots)
	assert(to_slot < max_slots)

	# This code is confusing the way it repeats but doesn't. But IDK how to fix it.
	var moving_item: Array = from_inv.items[from_slot]
	if items.has(to_slot):
		if items[to_slot][0] == from_inv.items[from_slot][0]:
			from_inv.items.erase(from_slot)
			items[to_slot][1] += moving_item[1]
		else:
			from_inv.items[from_slot] = items[to_slot]
			items[to_slot] = moving_item
	else:
		from_inv.items.erase(from_slot)
		items[to_slot] = moving_item


func remove_item(slot: int, count: int) -> void:
	assert(slot < max_slots)
	if items[slot][1] <= count:
		items.erase(slot)
	else:
		items[slot][1] -= count
