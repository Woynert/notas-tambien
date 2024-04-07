extends Control

@export var path_node_meta: NodePath
@export var path_node_agent: NodePath

@onready var node_meta: Node3D = get_node(path_node_meta)
@onready var node_agent: FPSPlayer = get_node(path_node_agent)
@onready var hand = %hand

const HAND_MODULATE = Color("ff00ff")

func _physics_process(delta):
	var from = Vector2(node_agent.body.global_position.x, node_agent.body.global_position.z)
	var to = Vector2(node_meta.global_position.x, node_meta.global_position.z)
	var dir_meta = from.direction_to(to)
	
	# TODO: Write an utility for this
	# TODO: get dir by basis
	# get dir by global Y angle
	var camera_angle = get_viewport().get_camera_3d().global_rotation.y
	var dir_view = Vector2.RIGHT.rotated(-camera_angle -PI/2) 
	hand.rotation = dir_view.angle_to(dir_meta)
	
	if abs(hand.rotation) < deg_to_rad(10):
		hand.self_modulate = HAND_MODULATE
	else:
		hand.self_modulate = Color.WHITE
