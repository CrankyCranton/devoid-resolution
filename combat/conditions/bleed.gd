class_name Bleed extends Condition
# Do conditions stack or merge? If stacked, it would be intuitive if
# bandages removed 1 bleed condition.
# TODO: Remove bleed condition after death, as well as all other conditions.
# Should probably be done within the player/enemy script. But that means they share inheritance?
# So instead of putting it in their scripts, it should probably be put in the modular death leaflet.


const BASE_TIME: float = 10.0

var bleeding: int = 10:
	set(value):
		bleeding = value
		if bleeding <= 0:
			queue_free()
var bleed_rate: float = 1.0

@warning_ignore("shadowed_variable_base_class")
func _init(target: Node, instigator: Node, bleeding: int, bleed_rate: float = 1.0) -> void:
	super(target, instigator)
	self.bleeding = bleeding
	self.bleed_rate = bleed_rate


func _ready() -> void:
	var bleed_ticker := Ticker.new(bleed_tick, _on_bleed_ticker_ticked)
	add_child(bleed_ticker)
	var congeal_ticker := Ticker.new(congeal_tick, _on_congeal_ticker_ticked)
	add_child(congeal_ticker)


func bleed_tick() -> float:
	return (BASE_TIME / bleeding) * bleed_rate


func congeal_tick() -> float:
	return BASE_TIME / target.health.congelation * (1.0 -
			maxf(target.health.health, 0.0) / target.health.max_health)


func _on_bleed_ticker_ticked() -> void:
	target.health.take_damage(Damage.new(Damage.Type.BLEED, 1, 1, 0.0, 1.0, 3), instigator)


func _on_congeal_ticker_ticked() -> void:
	bleeding -= 1
