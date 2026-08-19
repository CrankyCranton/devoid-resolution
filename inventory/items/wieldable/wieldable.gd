class_name Wieldable extends Node2D


#@export var turn_speed: float = 15.0

#var target_angle: float = 0.0


#func _process(delta: float) -> void:
	#rotation = lerp_angle(rotation, target_angle, minf(turn_speed * delta, 1.0))
	#transform.y = Vector2.DOWN if global_transform.x.x > 0.0 else Vector2.UP
