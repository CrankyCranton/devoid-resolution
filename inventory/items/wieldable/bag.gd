class_name Bag extends Wieldable
# Should non-aim items be able to be activated by double-clicking? For example,
# to open a inventory. Maybe aim items can be activated without wielding as well,
# but the direction will either be straight forward, or random. Because even
# when you're wielding an item, the item doesn't aim, the player character does.
# It's just hard to aim the character when your mouse needs to point at the inventory slot.
# If items can be activated without the wieldable spawned, where should the activation code be?
# It'll still need access to the wieldable direction/position if it exists.


@export var open_on_primary := true


func start(primary := true) -> void:
	printt("Called", primary, open_on_primary)
	if primary == open_on_primary:
		print("Activated")
		HUD.open_inventory(item, item.resource_name)
