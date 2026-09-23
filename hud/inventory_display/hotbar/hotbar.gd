class_name Hotbar extends Path2D
# The hotbar's selection is the sole thing in charge of wielding items.
# Clicking/dragging an item onto itself selects it (primary/secondary: left/right hands)
# Dragging an item from the hotbar onto something else *does not* select it.
# Hotkeys/scrollwheel only change the left hand selection. X swaps hand selections.
# Double-clicking on an item in an InventoryDisplay activates it without wielding. This doesn't
# work in the hotbar, as so not to confuse with selecting.

# But then how do you quickly open the inventory if the only root storage is the hotbar?
# Can the player decide which items activate in the hotbar when selected, and which ones are wielded?
# Or maybe each item has a setting for it. Though that reduces modularity and
# potential for emergence. How are guns opened? Do they have two actions?
# Answer: Trash dual wielding!!! (*O* ;)


signal item_selected(item: AbstractItem)

@export var inventory: Inventory

var selection: int

@onready var selection_ring: Sprite2D = $SelectionRing
@onready var slots: Node2D = $Slots
@onready var slot_arranger := SlotArranger.new(slots, inventory)
@onready var slot_count: int:
	get:
		return slots.get_child_count()


func _ready() -> void:
	slot_arranger.arrange_child.connect(_on_slot_arranger_arrange_child)
	slot_arranger.slot_selected.connect(_on_slot_arranger_slot_selected)
	slot_arranger.arrange()
	select(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"next_slot"):
		select(selection + 1)
	elif event.is_action_pressed(&"previous_slot"):
		select(selection - 1)
	# I'm still using input actions instead of reading the raw key numbers to support keybinds.
	for i: int in slot_count:
		if event.is_action_pressed("slot_" + str(i + 1)):
			select(i)


func select(index: int) -> void:
	selection = wrapi(index, 0, slot_count)
	var slot: DisplaySlot = slots.get_child(selection)
	selection_ring.position = slot.position
	item_selected.emit(slot.display_item.item if slot.display_item != null else null)


func _on_slot_arranger_arrange_child(child: Node, index: int, children: Array[Node]) -> void:
	var path_length: float = curve.get_baked_length() # WARNING: Could be performance heavy.
	child.position = curve.sample_baked((float(index) / children.size()) * path_length)


func _on_slot_arranger_slot_selected(slot: DisplaySlot) -> void:
	select(slot.index)
