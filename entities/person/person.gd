extends Node3D

enum ITEM {NONE, RULER, PENCIL, EXAM}

@onready var left_hand_node: Node3D = $LeftHand/item
@onready var right_hand_node: Node3D = $RightHand/item

@export var left_hand_item: ITEM = ITEM.NONE:
	set(v):
		left_hand_item = v
		_update_items()
@export var right_hand_item: ITEM = ITEM.NONE:
	set(v):
		right_hand_item = v
		_update_items()


func _ready():
	_update_items()

func _update_items():
	if left_hand_node:
		print(name)
		if left_hand_item == ITEM.NONE:
			left_hand_node.visible = false
		else:
			left_hand_node.visible = true
			var children = left_hand_node.get_children()
			for i in range(children.size()):
				var child = children[i]
				print(child)
				if (i+1) == left_hand_item:
					child.visible = true
					continue
				child.visible = false
	if right_hand_node:
		print(name)
		if right_hand_item == ITEM.NONE:
			right_hand_node.visible = false
		else:
			right_hand_node.visible = true
			var children = right_hand_node.get_children()
			for i in range(children.size()):
				var child = children[i]
				print(child)
				if (i+1) == right_hand_item:
					child.visible = true
					continue
				child.visible = false
	
