class_name Follow extends Move
# Make extend from a base movement class, put the movement functions in the agent, or both?


@export var desired_distance: float = 32.0
@warning_ignore("untyped_declaration")
## Can be Vector2 or Node2D, or NodePath.
@export_node_path("Node2D") var target
@export var blackboard_sync := &""


func _tick(delta: float) -> Status:
	if blackboard_sync != &"":
		target = blackboard.get_var(blackboard_sync)

	if target is NodePath:
		target = agent.get_node(target)
	if target is Node2D:
		target = target.global_position
	if not target is Vector2:
		return FAILURE

	if agent.global_position.distance_to(target) > desired_distance:
		set_direction()
		return super(delta)
	else:
		return SUCCESS


func set_direction() -> void:
	direction = agent.global_position.direction_to(target)
