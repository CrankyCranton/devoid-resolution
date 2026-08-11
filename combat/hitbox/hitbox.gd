class_name Hitbox extends Area2D


signal hit(damage: Damage, instigator: Node)


func take_damage(damage: Damage, instigator: Node) -> void:
	hit.emit(damage, instigator)
