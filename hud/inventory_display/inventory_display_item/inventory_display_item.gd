class_name InventoryDisplayItem extends TextureButton


const DROP_RADIUS: float = pow(32.0, 2.0)
const ITEM_ICON_LUT: Dictionary[PackedScene, Texture2D] = {
	preload("res://inventory/items/wieldable/guns/test_gun.tscn"):
			preload("res://assets/placeholder_icon.tres"),
	preload("res://interactable/interactable.tscn"):
			preload("uid://c2tu3lxqxnbs"),
}

var drag_start := Vector2.INF
var count: int:
	set(value):
		count = value
		count_hud.text = str(value)
var item: PackedScene:
	set(value):
		item = value
		texture_normal = ITEM_ICON_LUT[item]

@onready var count_hud: Label = $CountHUD


func _process(_delta: float) -> void:
	if drag_start != Vector2.INF:
		offset_transform_position = get_global_mouse_position() - drag_start


func _on_button_down() -> void:
	drag_start = get_global_mouse_position() - offset_transform_position


func _on_button_up() -> void:
	var current_slot: InventoryDisplaySlot = null
	var current_dist: float = INF
	for inventory_display_slot: InventoryDisplaySlot in get_tree().get_nodes_in_group(&"slots"):
		var pos: Vector2 = global_position
		var dist: float = pos.distance_squared_to(inventory_display_slot.global_position)
		if dist <= DROP_RADIUS and dist < current_dist:
			current_slot = inventory_display_slot
			current_dist = dist

	if current_slot != null:
		# Assumes the parent is always the slot this display item is in.
		var from_slot: InventoryDisplaySlot = get_parent()
		#assert(current_slot != from_slot)
		current_slot.inventory.move_item(from_slot.inventory, from_slot.index, current_slot.index)
		reparent(current_slot, false)

	offset_transform_position = Vector2.ZERO
	drag_start = Vector2.INF
