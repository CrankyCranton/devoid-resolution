class_name Gun extends Node2D


@export var PROJECTILE: PackedScene # Q: Should the projectile be synced with Magazine.AmmoType?
@export var magazine: Magazine
@export var automatic := false
@export var auto_reload := true

var holding_trigger := false
var can_shoot := true
var reload_mag: Magazine

@onready var barrel: Marker2D = $Barrel
@onready var cooldown: Timer = $Cooldown
@onready var reload_timer: Timer = $ReloadTimer


func _ready() -> void:
	if reload_mag == null:
		reload_mag = Magazine.new(magazine.type, -1) # If null, pull from an infinte supply.


func pull_trigger() -> void:
	holding_trigger = true
	if can_shoot:
		_shoot()


func release_trigger() -> void:
	holding_trigger = false


func reload() -> void:
	if magazine.ammo < 0:
		return # Guns with infinite ammo can't reload.
	if not reload_mag.has_ammo():
		# Play click sound.
		return

	can_shoot = false
	cooldown.stop()
	reload_timer.start()


func _shoot() -> void:
	if magazine.has_ammo():
		can_shoot = false
		var projectile: Node2D = PROJECTILE.instantiate()
		# global might have to be set after the node is in the scene tree.
		projectile.global_transform = barrel.global_transform
		add_sibling(projectile)
		cooldown.start()
	elif auto_reload:
		reload()
	else:
		pass # Play click sound.


func _on_cooldown_timeout() -> void:
	can_shoot = true
	if automatic and holding_trigger:
		_shoot()


func _on_reload_timer_timeout() -> void:
	# Since it's delayed, it's possible that reload_mag is empty by the time it tries to reload.
	# Shouldn't be a problem, though.
	magazine.reload(reload_mag)
	can_shoot = true
