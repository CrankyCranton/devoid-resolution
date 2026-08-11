class_name Move extends BTAction


@export var speed: float = 256.0
@export var accel: float = 15.0
@export var decel: float = 15.0

var direction: Vector2


func _tick(delta: float) -> Status:
	assert(agent is CharacterBody2D)
	agent = agent as CharacterBody2D
	var target_vel: Vector2 = direction * speed
	var traction: float = accel if target_vel.length() >= agent.velocity.length() else decel
	agent.velocity = agent.velocity.lerp(target_vel, traction * delta)
	agent.move_and_slide()
	return RUNNING
