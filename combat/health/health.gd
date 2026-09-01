class_name Health extends Node
# Extend from Resource? Might make ref counting more complicated,
# and connecting signals via GUI less convenient.


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
@export var heartless := false
## y is damage/secodns, x is at HP.
# Might want to seperate into a condition to make it applicable regardless of current health.
# In that case, there should also be a system to auto-stop bleeding over time,
# like in Shattered Pixel Dungeon.
# Thick blood can be represented through bleed damage resistance.
# Perhaps it can connected to temperature?
#func _process():
#	health -= bleed
#	bleed -= congelation
#	if bandage:
#		# Bandages should be able to completely patch up bleed damage for the most part.
#		bleed -= bandage
# TODO: Once bleed damage is converted to a condition, add the bleed damage to corruption.
@export var bleed_rate: Curve
@export var immune_time: float = 0.0
@export var vulnerabilities: Dictionary[Damage.Type, float]

var immune_timer := Timer.new()
var immune := false
var time_since_bled: float = 0.0
# TODO: Apply corruption to friendlies as well (any creature that's not the player or a boss).
# Instead of exclusively bosses and the player,
# maybe it doesn't apply to any creature with a "heartless" trait.
# Perhaps heart is a float multiplier. Call "warmth", "soul", or "sentience"?
# Change corruption to infamy/adrenaline, remove the instant death if corruption goes too high,
# and instead permanently reduce max health, and increase enemy agression/spawn rate
# on the level tied to the infamy?
var karma: int = 0:
	set(value):
		if heartless:
			return
		karma = value
		karma_changed.emit(karma)
var already_released_karma := false
var player: Player = null # Recorded if the player hit the enemy. NOTE: The player can hit himself.


func _ready() -> void:
	if immune_time > 0.0:
		_init_immune_timer()
	for hitbox: Hitbox in hitboxes:
		hitbox.hit.connect(_on_hitbox_hit)


func _process(delta: float) -> void:
	var is_bleeding: bool = bleed_rate != null and health <= bleed_rate.max_domain and health > 0
	if is_bleeding:
		time_since_bled += delta
		var time_until_next_bleed: float = 1.0 / bleed_rate.sample(health)
		while time_since_bled >= time_until_next_bleed:
			time_since_bled -= time_until_next_bleed
			# If the player hits a creature, it's always the player's fault if the creature bleeds.
			take_damage(Damage.new(Damage.Type.BLEED, 1, 1, 0.0, 1.0, 3), player)
			# Put into function? "do while" could be useful here.
			time_until_next_bleed = 1.0 / bleed_rate.sample(health)
	else:
		time_since_bled = 0.0


func _init_immune_timer() -> void:
	immune_timer.one_shot = true
	immune_timer.wait_time = immune_time
	immune_timer.timeout.connect(_on_immune_timer_timout)
	add_child(immune_timer)


func heal(healing: int) -> void:
	health += healing
	healed.emit(healing)


# Add support for residual damage? Maybe that would be better as a condition than damage type.
# Condition: Any temporary effect on a character.
# TODO: Multiply health by how much a bullet hit to the center.
# Probs more of a bullet script thing than health component thing.
func take_damage(damage: Damage, instigator: Node = null) -> void:
	var previous_released_karma: int = karma
	var damage_num: int = damage.get_damage()
	if vulnerabilities.has(damage.type):
		damage_num = floori(damage_num * vulnerabilities[damage.type])
	var excess: int = damage_num - maxi(0, health)
	health -= damage_num
	if instigator is Player:
		karma += damage.pain
	hurt.emit(damage_num)

	if health <= 0:
		if instigator is Player:
			karma += excess
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
