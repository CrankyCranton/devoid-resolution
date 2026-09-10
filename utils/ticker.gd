class_name Ticker extends Node
# The difference here from using a normal timer is that the remaining time is
# updated every frame, and it counts up instead of down.


signal ticked

# TODO: Add @export NodePath for convenience.
var tick: Callable = func(return_num: float = 1.0) -> float: return return_num
var time_since_tick: float = 0.0


func _init(tick := Callable(), callback := Callable()) -> void:
	if tick:
		self.tick = tick
	if callback:
		ticked.connect(callback)


func _process(delta: float) -> void:
	time_since_tick += delta
	while time_since_tick >= tick.call():
		time_since_tick -= tick.call() # Will calling it twice on a tick cause errors?
		ticked.emit()
