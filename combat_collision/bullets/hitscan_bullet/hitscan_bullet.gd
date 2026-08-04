class_name HitScanBullet extends RayCast2D


func _ready() -> void:
	force_raycast_update()
	if is_colliding() and get_collider() is Hitbox:
		pass
