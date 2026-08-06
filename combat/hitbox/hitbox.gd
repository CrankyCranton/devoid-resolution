class_name Hitbox extends Area2D


signal hit(damage: Damage, source: Node)


func take_damage(damage: Damage, source: Node) -> void:
	hit.emit(damage, source)
