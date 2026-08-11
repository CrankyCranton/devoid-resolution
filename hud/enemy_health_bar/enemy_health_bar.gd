@tool
class_name EnemyHealthBar extends HBoxContainer


@export var pixel_scale: float = 0.25
@export var health: int = 100:
	set(value):
		health = value
		set_bar(&"health_bar", health)
@export var karma: int = 0:
	set(value):
		karma = value
		set_bar(&"karma_bar", karma)

@onready var karma_bar: TextureRect = $KarmaBar
@onready var health_bar: TextureRect = $HealthBar


func _ready() -> void:
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	health = health
	karma = karma


func set_bar(bar: StringName, value: int) -> void:
	if not is_node_ready():
		await ready
	get(bar).custom_minimum_size.x = value * pixel_scale
