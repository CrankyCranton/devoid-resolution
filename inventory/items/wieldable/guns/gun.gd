class_name Gun extends Item


signal hurt(hitbox: Hitbox)

@export var BULLET: PackedScene # Q: Should the bullet scene be synced with Magazine.AmmoType?
@export var magazine: Magazine
@export var automatic := false
@export var auto_reload := true

var holding_trigger := false
var cooling := false
var reloading := false
var reload_mag: Magazine:
	get:
		return reload_mag if reload_mag != null else Magazine.new(magazine.type, 0)

@onready var barrel: Marker2D = $Barrel
@onready var cooldown: Timer = $Cooldown
@onready var reload_timer: Timer = $ReloadTimer


func pull_trigger() -> void:
	holding_trigger = true
	if not (reloading or cooling):
		_shoot()


func release_trigger() -> void:
	holding_trigger = false


func reload() -> void:
	if reloading:
		return
	if magazine.ammo <= -1:
		return # Guns with infinite ammo can't reload.
	if not reload_mag.has_ammo():
		# Play click sound.
		return

	reloading = true
	cooldown.stop()
	reload_timer.start()


func _shoot() -> void:
	if magazine.has_ammo():
		magazine.ammo -= 1
		cooling = true
		var bullet: Node2D = BULLET.instantiate()
		if bullet.has_signal(&"hurt"):
			bullet.hurt.connect(hurt.emit)
		bullet.global_transform = barrel.global_transform
		get_tree().current_scene.add_child(bullet)
		cooldown.start()
	elif auto_reload:
		reload()
	else:
		pass # Play click sound.


func _on_cooldown_timeout() -> void:
	cooling = false
	if automatic and holding_trigger:
		_shoot()


func _on_reload_timer_timeout() -> void:
	# Since it's delayed, it's possible that reload_mag is empty by the time it tries to reload.
	# Shouldn't be a problem, though.
	magazine.reload(reload_mag)
	reloading = false
