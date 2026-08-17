class_name SlotArranger extends Object
# When I want to make a script to extend another script's functionality,
# I wonder if extending from Object is good.


# In this case, the signal isn't a reaction, but a trigger. Hence the present-tense.
# I'm using a signal instead of a method call because it's more convenient to connect
# a signal than to pass a callable variable IMO.
signal arrange_child(child: Node, index: int, children: Array[Node])

var owner: Node


func _init(owner: Node) -> void:
	self.owner = owner
	owner.child_entered_tree.connect(_on_owner_child_entered_tree)
	owner.child_exiting_tree.connect(_on_owner_child_exiting_tree)
	owner.child_order_changed.connect(_on_owner_child_order_changed)


func arrange(ignore_nodes: Array[Node] = []) -> void:
	var children: Array[Node] = owner.get_children().filter(func(child: Node) -> bool:
			return not child in ignore_nodes)
	var i: int = 0
	for child: Node in children:
		arrange_child.emit(child, i, children.duplicate())
		i += 1


func _on_owner_child_entered_tree(_node: Node) -> void:
	arrange()


func _on_owner_child_exiting_tree(node: Node) -> void:
	# WARNING: Edge case: child_entered_tree could be emitted the same frame as
	# child_exiting_tree, making the removed node still arranged.
	arrange([node])


func _on_owner_child_order_changed() -> void:
	arrange()
