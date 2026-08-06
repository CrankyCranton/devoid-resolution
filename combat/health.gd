class_name Health extends Node
# Extend from Resource? Might make ref counting more complicated,
# and connecting signals via GUI less convenient.


signal died
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
@export var vulnerabilities: Dictionary[Damage.Type, float]


func heal(healing: int) -> void:
	health += healing
	healed.emit(healing)


# Add support for residual damage? Maybe that would be better as a condition than damage type.
# Condition: Any temporary effect on a character.
# TODO: Multiply health by how much a bullet hit to the center.
# Probs more of a bullet script thing than health component thing.
func take_damage(damage: Damage) -> void:
	var damage_num: int = damage.get_damage()
	if vulnerabilities.has(damage.type):
		damage_num = floori(damage_num * vulnerabilities[damage.type])
	health -= damage_num
	hurt.emit(damage_num)
	if health <= 0:
		died.emit()
