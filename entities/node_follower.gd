extends Node3D
class_name NodeFollower

@export var follow_position: bool = true
@export var follow_rotation: bool = false
@export var follow_node_path: NodePath
var follow_node = null

func _physics_process(delta):
	follow_node = get_node_or_null(follow_node_path)
	if follow_node:
		if follow_position:
			self.global_position = follow_node.global_position
		if follow_rotation:
			self.global_rotation = follow_node.global_rotation
