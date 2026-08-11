class_name HitScanBullet extends RayCast2D
# Should hitting accuratly increase damage, or increase the lower range of the rand damage?
# Leaning towards the later because it's different.
# Accuracy can be messured using Vector2.slide().
# Actually, I like the idea of no randomness/only using randomness for certain guns.
# Because randomness can be simulated by adding a random angle to the gun's aim.


signal hurt(hitbox: Hitbox)

@export var damage: Damage
@export var SHOOT_FX: PackedScene
@export var HIT_FX: PackedScene


func _ready() -> void:
	force_raycast_update()
	if is_colliding():
		if get_collider() is Hitbox:
			get_collider().take_damage(damage, self)
			hurt.emit(get_collider())
		add_fx(HIT_FX, Transform2D(0.0, (get_parent() as Node2D).to_local(get_collision_point())))
	add_fx(SHOOT_FX, global_transform) # Find way to give the scene the length of the trajectory?

	queue_free()


func add_fx(FX: PackedScene, trans: Transform2D) -> void:
	if FX == null:
		return
	var fx: Node2D = FX.instantiate()
	fx.global_transform = trans
	add_sibling(fx)
