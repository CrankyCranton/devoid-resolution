class_name Enemy extends CharacterBody2D


# TODO: Turn into component.
# In fact, do that for any and every system that isn't strictly for a specific use-case.
var health: int = 100


func _on_hitbox_hit(damage: int) -> void:
	health -= damage
