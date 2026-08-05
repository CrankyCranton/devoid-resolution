class_name Hitbox extends Area2D


signal hit(damage: int)


func take_damage(damage: int) -> void:
	hit.emit(damage)
