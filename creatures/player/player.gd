class_name Player extends Kinematic


const SPEED: float = 128.0
const MAX_HEALTH: int = 100
# TODO: Make it depend on the player's current weight of inventory/weapon.
const TURN_SPEED: float = 20.0

@onready var health: Health = $Health

var adernaline: int = 0
var corruption: int = 0:
	set(value):
		corruption = value
		HUD.set_corruption(corruption)


func _ready() -> void:
	HUD.set_max_health(health.max_health)
	HUD.set_health(health.health)


func _physics_process(delta: float) -> void:
	rotation = lerp_angle(rotation, global_position.angle_to_point(get_global_mouse_position()),
			TURN_SPEED * delta)
	var input: Vector2 = Input.get_vector(&"left", &"right", &"backward", &"forward")
	velocity = input * SPEED
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"primary"):
		$Hand/TestGun.pull_trigger()
	if event.is_action_released(&"primary"):
		$Hand/TestGun.release_trigger()


func _on_health_died(_krama: int) -> void:
	get_tree().paused = true


func _on_health_health_changed(health: int) -> void:
	HUD.set_health(health)


func _on_health_max_health_changed(max_health: int) -> void:
	HUD.set_max_health(max_health)
