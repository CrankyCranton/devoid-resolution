@tool class_name Inventory extends AbstractItem
# TODO: Think about if there will be any items like weapons that can't be stacked. If so, handle it.


const RAND_DROP_OFFSET: float = 16.0

# The use of the signals is primarily to update the inventory display.
signal item_created(slot: int, item: AbstractItem)
signal item_deleted(slot: int)
signal items_added(slot: int, count: int)
signal items_subtracted(slot: int, count: int)
signal full

@export var max_slots: int = 16 # Add support for changing max_slots dynamically in-game?
## In lb.
@export var max_weight: float = 100.0 # Should this be an int?
## Format: [<slot_idx>: <InventoryItem>]
@export var items: Dictionary[int, AbstractItem]

var owner: Node


func _init() -> void:
	super()
	# NOTE: Bags and other items with sub-resources can't be stacked,
	# else there would need to be a way to split sub_inventory when stacks are split.
	stackable = false


# Should there be an option for selecting a slot when adding items?
# Because the player may not be able to add items, but only move or remove them.
func add_item(item: AbstractItem) -> Error:
	var remaining_slots: PackedInt64Array = range(max_slots)
	for slot: int in items:
		assert(slot < max_slots)
		if items[slot].SCENE == item.SCENE:
			_add_items(slot, item.count)
			return OK
		else:
			remaining_slots.erase(slot)

	if remaining_slots.size() > 0:
		_create_item(remaining_slots[0], item)
		return OK
	else:
		full.emit()
		return ERR_CANT_CREATE


# WARNING: This function allows for creating multiple stacks of the same item
# by moving an item type you already have into a different slot.
func move_item(from_inv: Inventory, from_slot: int, to_slot: int) -> void:
	assert(from_slot < from_inv.max_slots)
	assert(to_slot < max_slots)

	# This code is confusing the way it repeats but doesn't. But IDK how to fix it.
	var moving_item: AbstractItem = from_inv.items[from_slot]
	if items.has(to_slot):
		if items[to_slot].SCENE == from_inv.items[from_slot].SCENE:
			if from_slot == to_slot and from_inv == self:
				push_warning("Moving item onto self; Move aborted.")
				return
			else:
				from_inv._delete_item(from_slot)
				_add_items(to_slot, moving_item.count)
		else:
			# NOTE: Performance can be increased by only emitting the item_deleted signal.
			from_inv._delete_item(from_slot)
			from_inv._create_item(from_slot, items[to_slot])

			_delete_item(to_slot)
			_create_item(to_slot, moving_item)
	else:
		from_inv._delete_item(from_slot)
		_create_item(to_slot, moving_item)


@warning_ignore("shadowed_variable_base_class")
func remove_item(slot: int, count: int) -> void:
	assert(slot < max_slots)
	@warning_ignore("standalone_ternary")
	_delete_item(slot) if items[slot].count <= count or count == -1 else _subtract_items(slot, count)


@warning_ignore("shadowed_variable_base_class")
func drop_item(slot: int, count: int) -> void:
	assert(count <= items[slot].count, "Can't drop more items than exist.")
	var dist: float = RAND_DROP_OFFSET * sqrt(sqrt(count))
	for i: int in count:
		var pickup: Pickup = preload("uid://cfnmmkeaw3xeo").instantiate()
		var item: AbstractItem = items[slot].duplicate(true)
		item.count = 1
		pickup.item = item
		pickup.position = owner.position + Utils.rand_vec2_radial(dist)
		owner.add_sibling(pickup)
	remove_item(slot, count)


func _create_item(slot: int, item: AbstractItem) -> void:
	item = item.duplicate(true)
	items[slot] = item
	item_created.emit(slot, item)


func _delete_item(slot: int) -> void:
	items.erase(slot)
	item_deleted.emit(slot)


@warning_ignore("shadowed_variable_base_class")
func _add_items(slot: int, count: int) -> void:
	items[slot].count += count
	items_added.emit(slot, count)


@warning_ignore("shadowed_variable_base_class")
func _subtract_items(slot: int, count: int) -> void:
	items[slot].count -= count
	items_subtracted.emit(slot, count)
