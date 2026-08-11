class_name Player extends Kinematic


const SPEED: float = 128.0
const MAX_CORRUPTION: int = 100
const MAX_HEALTH: int = 100
# TODO: Make it depend on the player's current weight of inventory/weapon.
const TURN_SPEED: float = 20.0

@onready var health: Health = $Health

var corruption: int = 0:
	set(value):
		corruption = value
		HUD.set_corruption(corruption)


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
