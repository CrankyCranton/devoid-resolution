extends CanvasLayer


@onready var corruption_bar: ProgressBar = %CorruptionBar
@onready var menu_dim: ColorRect = $MenuDim
@onready var menus: HFlowContainer = %Menus


func _ready() -> void:
	open_inventory(preload("uid://c4kc4u6tb3acj"), "Blah")


func set_corruption(corruption: int) -> void:
	corruption_bar.value = corruption


func open_inventory(inventory: Inventory, title := "Items") -> void:
	menu_dim.show()
	var inventory_display: InventoryDisplay = preload("uid://hf8uovgvp6bv").instantiate()
	inventory_display.inventory = inventory
	menus.add_child(inventory_display)
	# The common practice would be to make a setter var/func for this, but I'm lazy.
	inventory_display.title.text = title


func _on_menus_child_exiting_tree(_node: Node) -> void:
	# Excluding the node exiting. Could break if multiple nodes are deleted in 1 frame.
	if menus.get_child_count() <= 1:
		menu_dim.hide()
