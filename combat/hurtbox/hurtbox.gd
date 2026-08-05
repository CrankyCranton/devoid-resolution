class_name Hurtbox extends Area2D


@export var damage: Damage

var already_hit: Array[Node]


func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox.owner in already_hit:
		return
	
	hitbox.take_damage(damage.get_damage())
	already_hit.append(hitbox.owner)
