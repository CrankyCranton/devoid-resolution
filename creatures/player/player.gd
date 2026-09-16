class_name Player extends Kinematic


const SPEED: float = 128.0
const MAX_HEALTH: int = 100
# TODO: Make it depend on the player's current weight of inventory/weapon.
const TURN_SPEED: float = 20.0

var adrenaline: int = 0:
	set(value):
		adrenaline = value
		player_hud.set_adrenaline(value)
var corruption: int = 0:
	set(value):
		corruption = value
		player_hud.set_corruption(corruption)

@onready var health: Health = $Health
@onready var hand_l: Hand = $HandL
@onready var hand_r: Hand = $HandR # Probs not needed.
@onready var player_hud: PlayerHUD = $PlayerHUD


func _ready() -> void:
	var adrenaline_ticker := Ticker.new(func() -> float: return 0.5, _on_adrenaline_ticker_ticked)
	add_child(adrenaline_ticker)
	player_hud.set_max_health(health.max_health)
	player_hud.set_health(health.health)


func _physics_process(delta: float) -> void:
	rotation = lerp_angle(rotation, global_position.angle_to_point(get_global_mouse_position()),
			TURN_SPEED * delta)
	var input: Vector2 = Input.get_vector(&"left", &"right", &"backward", &"forward")
	velocity = input * SPEED
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"primary"):
		hand_l.start()
	if event.is_action_released(&"primary"):
		hand_l.stop()


func add_adrenaline() -> void:
	# Should the adrenaline bonus be stored on the health/creature script?
	# Maybe it's determined by a random percentage of the creature's max HP?
	# Then I should think about the HP ratios of enemies to each other.
	# If adrenaline is a fixed number instead of a multiplier, it means
	# that it's much more effective to low-damage low-cooldown weapons.
	# Starting to think it should be a bonus percentage. That's how it's displayed anyway.
	adrenaline += randi_range(5, 10)


func _on_health_died(_krama: int) -> void:
	get_tree().paused = true


func _on_health_health_changed(health: int) -> void:
	player_hud.set_health(health)


func _on_health_max_health_changed(max_health: int) -> void:
	player_hud.set_max_health(max_health)


func _on_adrenaline_ticker_ticked() -> void:
	adrenaline = maxi(0, adrenaline - 1)


func _on_hotbar_item_selected(item: AbstractItem) -> void:
	if not is_node_ready():
		await ready
	hand_l.unwield()
	hand_l.wield(item)
