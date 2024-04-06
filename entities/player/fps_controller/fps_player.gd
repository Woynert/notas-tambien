extends Playable
class_name FPSPlayer

@onready var body: CharacterBody3D = $FPSController
@export_range(-360, 360) var initial_camera_angle: float = 0.0
@export var max_speed_override: float = 0.0


func _ready():
	body.set_process(false)
	body.set_physics_process(false)
	var disable_shape = func x():
		body.get_node("CollisionShape3D").disabled = true
	disable_shape.call_deferred()
	
	body.head.disable()
	(body.head as Node3D).rotate_y(deg_to_rad(initial_camera_angle))
	
	if max_speed_override != 0:
		body.MAX_SPEED = max_speed_override


func start():
	print("starting %s" % name)
	body.set_process(true)
	body.set_physics_process(true)
	body.get_node("CollisionShape3D").disabled = false
	body.head.enable()
	body.head.get_camera().make_current()
	

func end():
	print("ending %s" % name)
	body.set_process(false)
	body.set_physics_process(false)
	body.get_node("CollisionShape3D").disabled = true
	body.head.disable()
