class_name Damage extends Resource
# Add ignoring logic here?


enum Type {
	REGULAR,
}

@export var type: Type
@export var minimum: int = 10
@export var maximum: int = 20
@export var crit_chance: float = 0.05 # Maybe this should be moved to a different script.
@export var crit_multiplier: float = 2.0


func _init(type := self.type, minimum := self.minimum, maximum := self.maximum,
		crit_chance := self.crit_chance, crit_multiplier := self.crit_multiplier) -> void:
	self.type = type
	self.minimum = minimum
	self.maximum = maximum
	self.crit_chance = crit_chance
	self.crit_multiplier = crit_multiplier


func get_damage() -> int:
	var crit: float = 1.0 + (float(randf() <= crit_chance) * crit_multiplier)
	return floori(randi_range(minimum, maximum) * crit)
