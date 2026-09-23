class_name Hand extends Marker2D


var has_item: bool:
	get:
		return get_child_count() > 0


func start() -> void:
	if has_item:
		get_child(0).start()
	else:
		pass # Punch


func stop() -> void:
	if has_item:
		get_child(0).stop()


# Making this a seperate function assumes the rest of the inventory system will
# handle what items are wielded/unwielded when swapped.
func unwield() -> void:
	if has_item:
		# Will items need to save data when unloaded? If so, the data can be stored
		# on the AbstractItem resource. E.g., guns can store the ammo resource on the AbstractItem.
		get_child(0).queue_free()


func wield(item: AbstractItem) -> void:
	unwield()
	if item != null:
		var wieldable: Wieldable = item.SCENE.instantiate()
		add_child(wieldable)
		wieldable.owner = self.owner
