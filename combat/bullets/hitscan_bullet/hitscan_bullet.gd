class_name HitScanBullet extends RayCast2D


@export var damage: Damage


func _ready() -> void:
	force_raycast_update()
	if is_colliding() and get_collider() is Hitbox:
		get_collider().take_damage(damage.get_damage())
	queue_free()
