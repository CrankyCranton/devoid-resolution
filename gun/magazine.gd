@tool
class_name Magazine extends Resource


enum BulletTypes {
	REGULAR,
}

@export var type: BulletTypes
# < 0 is infinite.
@export var max_ammo: int = -1:
	set(value):
		max_ammo = value
		ammo = ammo # Call setter.
@export var ammo: int = -1:
	set(value):
		ammo = clampi(value, mini(0, max_ammo), max_ammo)


func _init() -> void:
	resource_local_to_scene = true


func reload(from_mag: Magazine) -> void:
	if from_mag.type != type:
		push_error(self, ": required ammo type ", type,
				" does not match given type ", from_mag.type, " from magazine ", from_mag)
		return
	
	# Somewhat bug prone for now, will come back and refine later.
	if from_mag.ammo <= -1:
		ammo = max_ammo
	elif ammo >= 0:
		var amount: int = mini(from_mag.ammo, max_ammo - ammo)
		ammo += amount
		from_mag.ammo -= amount


func can_shoot() -> bool:
	return ammo != 0
