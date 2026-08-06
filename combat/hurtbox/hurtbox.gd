class_name Hurtbox extends Area2D


signal hurt(hitbox: Hitbox)

@export var damage: Damage
@export var ignore_list: Array[Node] ## Can contain Hitboxes or Hitbox owners.
@export var ignore_after_first_hit := false

var already_hit: Array[Node] # TODO: Find way to clear already_hit when the Hurtbox is disabled.


func _on_area_entered(hitbox: Hitbox) -> void:
	if ((ignore_after_first_hit and hitbox.owner in already_hit)
			or hitbox.owner in ignore_list or hitbox in ignore_list):
		return

	hitbox.take_damage(damage, self)
	already_hit.append(hitbox.owner)
	hurt.emit(hitbox)
