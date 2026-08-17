class_name Hotbar extends Path2D


var slot_arranger := SlotArranger.new(self)


func _init() -> void:
	slot_arranger.arrange_child.connect(_on_slot_arranger_arrange_child)


func _on_slot_arranger_arrange_child(child: Node, index: int, children: Array[Node]) -> void:
	var path_length: float = curve.get_baked_length() # WARNING: Could be performance heavy.
	child.position = curve.sample_baked((float(index + 1) / children.size()) * path_length)
