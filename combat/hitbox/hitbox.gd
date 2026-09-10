class_name Hitbox extends Area2D


signal hit(damage: Damage, instigator: Node)


func take_damage(damage: Damage, instigator: Node) -> void:
	# TODO: Move to a better place. Maybe it's applied within damage.gd? Although
	# then I'll need to be careful about linked damage resources sharing instigator.
	if instigator is Player:
		damage.minimum += instigator.adrenaline
		damage.maximum += instigator.adrenaline
	hit.emit(damage, instigator)
