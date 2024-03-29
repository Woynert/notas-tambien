extends CharacterBody3D

@export var head: Node3D
const ACC = 0.8
const ACC_AIR = 0.3
const ACC_TURN = ACC * 1.7
const FRICTION = 0.6
const FRICTION_AIR = 0
const JUMP_VELOCITY = 6.5
const GRAVITY = 9.8 * 2
var MAX_SPEED = 17.0


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# input direction and handle the movement/deceleration.
	var basis = transform.basis
	if head:
		basis = head.transform.basis
	var input_dir = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	var direction = (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		var acc_x = ACC
		var acc_z = ACC
		if not is_on_floor():
			acc_x = ACC_AIR
			acc_z = ACC_AIR
		if sign(direction.x) != sign(velocity.x):
			acc_x = ACC_TURN
		if sign(direction.z) != sign(velocity.z):
			acc_z = ACC_TURN
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction.x, acc_x)
		velocity.z = move_toward(velocity.z, MAX_SPEED * direction.z, acc_z)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			velocity.z = move_toward(velocity.z, 0, FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION_AIR)
			velocity.z = move_toward(velocity.z, 0, FRICTION_AIR)
	
	move_and_slide()
