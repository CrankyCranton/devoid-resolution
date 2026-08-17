class_name Inventory extends Resource


@export var max_slots: int = -1
@export var items: Array[Dictionary]

#
### Leave slot at -1 to automatically assign a slot.
#func add_item(item: PackedScene, count: int = 1, slot: int = -1) -> void:
	#if items.has(item):
		#items[item] = 1
	#else:
		#items[item] += 1
#
#
#func move_item()
#
#
#func remove_item(item: PackedScene, count: = 1) -> void:
	#items[item] -= 1
	#if items[item] <= 0:
		#items.erase(item)
