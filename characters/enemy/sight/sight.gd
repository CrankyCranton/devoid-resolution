class_name Sight extends Area2D


signal collider_entered(collider: Node2D)
signal collider_exited(collider: Node2D)

# Wondering if I should create a small convenience class for random ranges.
# But then it would need to have flexibility for things like int vs float, etc.
@export var min_notice_time: float = 0.5 
@export var max_notice_time: float = 3.0

var visible_colliders: Array[Node2D]
## {<Collider>: [<time_since_in_los>, <time_needed_to_notice>]}
var notice_times: Dictionary[Node2D, PackedFloat64Array] # Could also be Float32.

## LOS should only collide with things that would block line-of-sight, not the collider itself.
@onready var los: RayCast2D = $LOS


func _physics_process(delta: float) -> void:
	var colliders: Array[Node2D] = get_overlapping_bodies()
	colliders.append_array(get_overlapping_areas())
	for collider: Node2D in colliders:
		los.target_position = los.to_local(collider.global_position)
		los.force_raycast_update()

		if los.is_colliding():
			_exit_collider(collider)

		elif not visible_colliders.has(collider):
			if notice_times.has(collider):
				notice_times[collider][0] += delta
			else:
				notice_times[collider] = [0.0, randf_range(min_notice_time, max_notice_time)]
			if notice_times[collider][0] >= notice_times[collider][1]:
				visible_colliders.append(collider)
				collider_entered.emit(collider)


func _exit_collider(collider: Node2D) -> void:
	if notice_times.has(collider):
		notice_times.erase(collider)
	if collider in visible_colliders:
		visible_colliders.erase(collider)
		collider_exited.emit(collider)


func _on_collider_exited(collider: Node2D) -> void:
	_exit_collider(collider)
