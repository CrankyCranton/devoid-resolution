class_name PickWanderDir extends BTAction


@export var output_var: StringName


func _tick(_delta: float) -> Status:
	blackboard.set_var(output_var, Utils.rand_vec2_dir())
	return SUCCESS
