extends CanvasLayer


@onready var corruption_bar: TextureProgressBar = %CorruptionBar
@onready var menu_dim: ColorRect = %MenuDim
@onready var menus: HFlowContainer = %Menus
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var adrenaline_hud: Label = %AdrenalineHUD
@onready var warmth_hud: Label = %WarmthHUD


#func _ready() -> void:
	#open_inventory(preload("uid://c4kc4u6tb3acj"), "Blah")


func set_corruption(corruption: int) -> void:
	corruption_bar.value = corruption


func set_health(health: int) -> void:
	health_bar.value = health


func set_max_health(max_health: int) -> void:
	health_bar.max_value = max_health


func set_adrenaline(adrenaline: int) -> void:
	adrenaline_hud.text = "Adrenaline: " + str(adrenaline) + "%"


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
