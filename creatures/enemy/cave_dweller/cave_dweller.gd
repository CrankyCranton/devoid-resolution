class_name CaveDweller extends Enemy
# TODO: Add knockback from attacks.


const DESIRED_SEARCH_POINT_DISTANCE: float = pow(32.0, 2.0)
const ATTACK_RANGE: float = pow(64.0, 2.0)

# Should probably rely on the blackboard more to store variables,
# so that variables won't be everywhere.
@export var player: Player
@export var search_point := Vector2.INF

var on_wall: bool:
	get:
		return is_on_wall()
var is_within_range: bool:
	get:
		return global_position.distance_squared_to(player.global_position) <= ATTACK_RANGE


func _physics_process(_delta: float) -> void:
	if global_position.distance_squared_to(search_point) <= DESIRED_SEARCH_POINT_DISTANCE:
		search_point = Vector2.INF


func _on_sight_collider_entered(collider: Node2D) -> void:
	player = collider


func _on_sight_collider_exited(collider: Node2D) -> void:
	if collider == player:
		search_point = player.global_position
		player = null


# TODO: Replace with hearing system so the enemy will be alerted even if the player misses.
# The hearing system should also support things like throwing rocks.
func _on_hitbox_hit(_damage: Damage, instigator: Node) -> void:
	search_point = instigator.global_position
