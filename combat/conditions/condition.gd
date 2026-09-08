class_name Condition extends Node
# Conditions are duck typed.


var instigator: Node
var target: Node


# Because conditions are instantiated via _init(), they won't work the same with scene instantiation.
func _init(target: Node, instigator: Node) -> void:
	self.instigator = instigator
	self.target = target
	target.add_child(self)
