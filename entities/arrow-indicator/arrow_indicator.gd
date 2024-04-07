extends Node3D

const ANGLE_INCREMENT = 0.02
const DELTA_HEIGHT = 0.5
const COS_FACTOR = 1/15.0
@onready var visual_node = $visual


func _physics_process(delta):
	visual_node.position.y = sin(Engine.get_process_frames() * COS_FACTOR) * DELTA_HEIGHT
	visual_node.rotation.y += ANGLE_INCREMENT
