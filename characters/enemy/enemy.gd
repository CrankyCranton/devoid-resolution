class_name Enemy extends Kinematic


@onready var health: Health = $Health
@onready var bt_player: BTPlayer = $BTPlayer


func _on_hitbox_hit(damage: Damage, _source: Node) -> void:
	health.take_damage(damage)


func _on_health_died(_excess_damage: int) -> void:
	queue_free()
