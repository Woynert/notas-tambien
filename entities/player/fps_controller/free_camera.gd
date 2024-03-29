extends Node3D
class_name FreeCamera

@export var enabled = true
@onready var head = self as Node3D
@onready var camera = $headCamera as Camera3D

var mouseSensibility = 800


func _ready():
	if enabled:
		enable()
	else:
		disable()


func enable():
	set_process_input(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func disable():
	set_process_input(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event):
	if event is InputEventMouseMotion:
		head.rotation.y -= event.relative.x / mouseSensibility
		camera.rotation.x -= event.relative.y / mouseSensibility
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90) )


func get_aim() -> Vector3:
	return Vector3(camera.rotation.x, head.rotation.y, 0)


func get_camera() -> Camera3D:
	return camera
