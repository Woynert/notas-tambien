extends Node3D

enum ITEM {NONE, RULER, PENCIL, EXAM}

@onready var item_node: Node3D = self
@export var item: ITEM = ITEM.NONE:
	set(v):
		item = v
		_update_items()


func _ready():
	item_node = self
	_update_items()


func _update_items():
	item_node = self
	print(name)
	if item == ITEM.NONE:
		item_node.visible = false
	else:
		item_node.visible = true
		var children = item_node.get_children()
		for i in range(children.size()):
			var child = children[i]
			print(child)
			if (i+1) == item:
				child.visible = true
				continue
			child.visible = false
