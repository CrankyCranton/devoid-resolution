class_name Rotator extends BTAction


# Very similar target code to move.gd. Might be able to merge them somehow.
@warning_ignore("untyped_declaration")
@export_node_path("Node2D") var target
@export var blackboard_sync := &""
@export var turn_speed: float = 15.0
@export var desired_difference := 1.0


func _tick(delta: float) -> Status:
	if blackboard_sync != &"":
		target = blackboard.get_var(blackboard_sync)

	if target is NodePath:
		target = agent.get_node(target)
	if target is Node2D:
		target = target.global_position
	if target is Vector2:
		target = agent.global_position.angle_to_point(target)
	if not target is float:
		return FAILURE

	if absf(angle_difference(agent.global_rotation, target)) > deg_to_rad(desired_difference):
		var lerping: float = minf(turn_speed * delta, 1.0)
		agent.global_rotation = lerp_angle(agent.global_rotation, target, lerping)
		return SUCCESS

	return RUNNING
