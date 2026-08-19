class_name Hotbar extends Path2D


@export var inventory: Inventory

@onready var slot_arranger := SlotArranger.new(self, inventory)


func _ready() -> void:
	slot_arranger.arrange_child.connect(_on_slot_arranger_arrange_child)
	slot_arranger.arrange()


func _on_slot_arranger_arrange_child(child: Node, index: int, children: Array[Node]) -> void:
	var path_length: float = curve.get_baked_length() # WARNING: Could be performance heavy.
	child.position = curve.sample_baked((float(index + 1) / children.size()) * path_length)
