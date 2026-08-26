class_name Move extends BTAction


@export var speed: float = 256.0
@export var accel: float = 15.0
@export var decel: float = 15.0
# TODO: Once LimboAI fixes the bug where @export "_var"(s) are reset whenever
# the script is changed, remove "_str".
@export var direction_var_str: StringName
@export var relative_dir := false

# Making setter & getter functions for every blackboard variable is
# going to be a pain, so I should find a better workflow around this.
var direction: Vector2:
	set(value):
		blackboard.set_var(direction_var_str, value)
	get:
		return blackboard.get_var(direction_var_str, Vector2.ZERO, false)


func _tick(delta: float) -> Status:
	assert(agent is CharacterBody2D)
	agent = agent as CharacterBody2D
	var target_vel: Vector2 = direction * speed
	if relative_dir:
		target_vel = target_vel.rotated(agent.global_rotation)
	# NOTE: Can also be changed to lerping to make the transition from
	# acceleration to deceleration smooth. Although that might reduce the surprise
	var avg: Vector2 = (target_vel + agent.velocity) / 2.0
	var traction: float = accel if avg.length() > agent.velocity.length() else decel
	agent.velocity = agent.velocity.lerp(target_vel, traction * delta)
	agent.move_and_slide()
	return RUNNING
