class_name Health extends Node
# Extend from Resource? Might make ref counting more complicated,
# and connecting signals via GUI less convenient.
# Rule of thumb: Use nodes for things that do, and resources for things that store.


signal died(karma: int)
signal karma_changed(karma: int)
signal hurt(damage: int)
signal healed(healing: int)
signal health_changed(health: int)
signal max_health_changed(max_health: int)

@export var hitboxes: Array[Hitbox] = []
@export var max_health: int = 100:
	set(value):
		max_health = value
		max_health_changed.emit(max_health)
		health = health # Call setter.
@export var health: int = 100:
	set(value):
		health = mini(value, max_health)
		health_changed.emit(health)
@export var soul: float = 1.0
# Should congelation be applied here or in bleed.gd? (currently bleed.gd)
@export var congelation: int = 5
# If warmth also affects stamina, and stamina affects movement,
# should warmth be made it's own module? If it's put into it's own script,
# will health still need some porting variables to it?
@export var base_warmth: int = 98
@export var base_insulation: float = 1.0
@export var immune_time: float = 0.0
@export var vulnerabilities: Dictionary[Damage.Type, float]
@export var armour: Array[PackedScene] # Not stored on health, but given to health.

var immune_timer := Timer.new()
var immune := false
var karma: int = 0:
	set(value):
		karma = value
		karma_changed.emit(karma)
var already_released_karma := false
var player: Player = null # Recorded if the player hit the enemy. NOTE: The player can hit himself.


func _ready() -> void:
	if immune_time > 0.0:
		_init_immune_timer()
	for hitbox: Hitbox in hitboxes:
		hitbox.hit.connect(_on_hitbox_hit)


func _init_immune_timer() -> void:
	immune_timer.one_shot = true
	immune_timer.wait_time = immune_time
	immune_timer.timeout.connect(_on_immune_timer_timout)
	add_child(immune_timer)


func heal(healing: int) -> void:
	health += healing
	healed.emit(healing)


func take_damage(damage: Damage, instigator: Node = null) -> void:
	var previous_released_karma: int = karma
	var damage_num: int = damage.get_damage()
	if vulnerabilities.has(damage.type):
		damage_num = floori(damage_num * vulnerabilities[damage.type])
	var excess: int = damage_num - maxi(0, health)
	health -= damage_num
	if instigator is Player:
		karma += floori(damage.pain * soul)
	hurt.emit(damage_num)

	if health <= 0:
		if instigator is Player:
			karma += floori(excess * soul)
		if player != null:
			var adding_karma: int = karma
			if already_released_karma:
				adding_karma -= previous_released_karma
			player.corruption += adding_karma
			already_released_karma = true
		died.emit(karma)


func _on_hitbox_hit(damage: Damage, instigator: Node) -> void:
	if immune:
		return

	if instigator is Player:
		player = instigator
	take_damage(damage, instigator)

	if immune_time > 0.0:
		immune = true
		immune_timer.start()


func _on_immune_timer_timout() -> void:
	immune = false
