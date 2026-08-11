class_name Damage extends Resource
# Add ignoring logic here?


enum Type {
	REGULAR,
# Could also be inflicted by things like vampires or leeches?
# Could allow the player to use things like bandages for protection against those enemies as well.
# If it's residual damage, then it should probably be a condition.
	BLEED,
}

@export var type: Type
@export var minimum: int = 10
@export var maximum: int = 20
@export var crit_chance: float = 0.05 # Maybe this should be moved to a different script.
@export var crit_multiplier: float = 2.0
@export var pain: int = 5


func _init(type := self.type, minimum := self.minimum, maximum := self.maximum,
		crit_chance := self.crit_chance, crit_multiplier := self.crit_multiplier,
		pain := self.pain) -> void:
	self.type = type
	self.minimum = minimum
	self.maximum = maximum
	self.crit_chance = crit_chance
	self.crit_multiplier = crit_multiplier
	self.pain = pain


func get_damage() -> int:
	var damage: int = randi_range(minimum, maximum)
	if randf() <= crit_chance:
		damage = floori(damage * crit_multiplier)
	return damage
