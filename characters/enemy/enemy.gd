class_name Enemy extends CharacterBody2D


@onready var health: Health = $Health


func _on_hitbox_hit(damage: Damage, _source: Node) -> void:
	health.take_damage(damage)


func _on_health_died() -> void:
	queue_free()
