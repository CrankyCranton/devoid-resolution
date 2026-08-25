class_name Move extends BTAction


@export var speed: float = 256.0
@export var accel: float = 15.0
@export var decel: float = 15.0
@export var direction_var: StringName
@export var relative_dir := false

# Making setter & getter functions for every blackboard variable is
# going to be a pain, so I should find a better workflow around this.
var direction: Vector2:
	set(value):
		blackboard.set_var(direction_var, value)
	get:
		return blackboard.get_var(direction_var, Vector2.ZERO, false)


func _tick(delta: float) -> Status:
	assert(agent is CharacterBody2D)
	agent = agent as CharacterBody2D
	var target_vel: Vector2 = direction * speed
	if relative_dir:
		target_vel = target_vel.rotated(agent.global_rotation)
	var traction: float = accel if target_vel.length() >= agent.velocity.length() else decel
	agent.velocity = agent.velocity.lerp(target_vel, traction * delta)
	agent.move_and_slide()
	return RUNNING
