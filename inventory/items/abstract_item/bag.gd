class_name Bag extends AbstractItem
# The spawned wieldable will need access to sub_inventory somehow.
# In general, I think wieldable should have access to the AbstractItem it was derrived from,
# in case the item has an auto-destruct feature, or something of the like.
# Should non-aim items be able to be activated by double-clicking? For example,
# to open a sub-inventory. Maybe aim items can be activated without wielding as well,
# but the direction will either be straight forward, or random. Because even
# when you're wielding an item, the item doesn't aim, the player character does.
# It's just hard to aim the character when your mouse needs to point at the inventory slot.
# If items can be activated without the wieldable spawned, where should the activation code be?
# It'll still need access to the wieldable direction/position if it exists.


@export var sub_inventory: Inventory
