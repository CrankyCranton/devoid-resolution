class_name InventoryDisplayItem extends TextureButton


var drag_start := Vector2.INF


func _process(_delta: float) -> void:
	if drag_start != Vector2.INF:
		offset_transform_position = get_global_mouse_position() - drag_start


func _on_button_down() -> void:
	drag_start = get_global_mouse_position() - offset_transform_position


func _on_button_up() -> void:
	offset_transform_position = Vector2.ZERO
	drag_start = Vector2.INF
