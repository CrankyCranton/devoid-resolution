class_name InventoryDisplaySlot extends TextureRect


@export var reserve_slot := false

var item: InventoryDisplayItem
var reserved_item: PackedScene = null
var inventory: Inventory = null
# This could also be represented through child index, but I'm keeping
# it as a seperate variable for now to keep things simple.
var index: int


func _ready() -> void:
	# Match the slot against the index to see if it's relevant to this slot.
	inventory.items_added.connect(_on_inventory_items_added)
	inventory.items_subtracted.connect(_on_inventory_items_subtracted)
	inventory.item_created.connect(_on_inventory_item_created)
	inventory.item_deleted.connect(_on_inventory_item_deleted)


func create_item(item: PackedScene, count: int) -> void:
	if get_child_count() > 0:
		push_warning(get_child_count(), " items already present in slot!")

	var inventory_display_item: InventoryDisplayItem = preload("uid://bh1kph1si1x55").instantiate()
	add_child(inventory_display_item)
	inventory_display_item.item = item
	inventory_display_item.count = count


func _on_inventory_item_created(slot: int, item: PackedScene, count: int) -> void:
	if slot == index:
		create_item(item, count)


func _on_inventory_item_deleted(slot: int) -> void:
	if slot == index:
		get_child(0).queue_free()


# NOTE: Might be good to change "count" from relative to absolute to prevent de-syncing.
func _on_inventory_items_added(slot: int, count: int) -> void:
	if slot == index:
		get_child(0).count += count


func _on_inventory_items_subtracted(slot: int, count: int) -> void:
	if slot == index:
		get_child(0).count -= count
