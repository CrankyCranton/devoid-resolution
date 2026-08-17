class_name InventoryDisplay extends PanelContainer


@export var inventory: Inventory
@export var columns: int = 8
@export var editable := true

@onready var slots: Control = %Slots
@onready var slot_arranger := SlotArranger.new(slots)


func _ready() -> void:
	slot_arranger.arrange_child.connect(_on_slot_arranger_arrange_child)
	slot_arranger.arrange()


func _on_slot_arranger_arrange_child(child: Node, index: int, _children: Array[Node]) -> void:
	# See https://codeforces.com/blog/entry/154581 for more info.
	#var in_diameter: float = maxf(item_size.x, item_size.y)
	#var hex_size: float = in_diameter / sqrt(3.0)
	#var spacing_h: float = in_diameter
	#var spacing_v: float = 1.5 * hex_size
	var spacing_h: float = 28.0
	var spacing_v: float = 1.5 * (spacing_h / sqrt(3.0))

	@warning_ignore("integer_division")
	var coords := Vector2i(index % columns, index / columns)
	child.position = Vector2(coords) * Vector2(spacing_h, spacing_v)
	child.position.x += (spacing_h / 2.0) * (coords.y % 2)

	slots.custom_minimum_size = slots.custom_minimum_size.max(child.position + child.size)
