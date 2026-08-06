@tool
class_name Magazine extends Resource


enum AmmoType {
	REGULAR,
}

@export var type: AmmoType
# < 0 is infinite.
@export var max_ammo: int = -1:
	set(value):
		max_ammo = maxi(value, -1)
		ammo = max_ammo if ammo <= -1 else ammo # Call setter.
@export var ammo: int = -1:
	set(value):
		ammo = clampi(value, mini(0, max_ammo), max_ammo)


func _init(type := self.type, max_ammo := self.max_ammo, ammo := self.ammo) -> void:
	self.type = type
	self.max_ammo = max_ammo
	self.ammo = ammo
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


func has_ammo() -> bool:
	return ammo != 0
