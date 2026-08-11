class_name Enemy extends Kinematic
# TODO: Merge some behavior into a base creature script.
# The problem: Some creatures might not move, and thus wouldn't need to be CharacterBody2D(s).
# Solution: Only make Kinematic do kinematic stuff. Problem solved.


var dead := false

@onready var health: Health = $Health
@onready var bt_player: BTPlayer = $BTPlayer
@onready var enemy_health_bar: EnemyHealthBar = $EnemyHealthBar


func _on_health_health_changed(health: int) -> void:
	enemy_health_bar.health = health


func _on_health_karma_changed(karma: int) -> void:
	enemy_health_bar.karma = karma


func _on_health_died(_karma: int) -> void:
	dead = true
