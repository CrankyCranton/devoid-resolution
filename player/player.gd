class_name Player extends CharacterBody2D
# NOTE: If enemies and player have things in common about movement like traction,
# it might be a good idea to make them both extend from a base class.


const SPEED: float = 128.0
const MAX_CORRUPTION: int = 100
const MAX_HEALTH: int = 100

var health: int = MAX_HEALTH
var corruption: int = 0


func _physics_process(_delta: float) -> void:
	var input: Vector2 = Input.get_vector(&"left", &"right", &"backward", &"forward")
	velocity = input * SPEED
	move_and_slide()
