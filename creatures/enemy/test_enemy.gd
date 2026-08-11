extends Enemy


@export var player: Player


func _on_sight_collider_entered(collider: Node2D) -> void:
	player = collider


func _on_sight_collider_exited(collider: Node2D) -> void:
	if collider == player:
		player = null
