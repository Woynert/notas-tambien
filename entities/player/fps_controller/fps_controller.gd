extends CharacterBody3D

@export var head: Node3D
const ACC = 0.8
const ACC_AIR = 0.3
const ACC_TURN = ACC * 0.8
const FRICTION = 0.6
const FRICTION_AIR = 0
const JUMP_VELOCITY = 6.5
const GRAVITY = 9.8 * 2
var MAX_SPEED = 17.0


func _physics_process(delta):
	var max_speed = MAX_SPEED
	if Input.is_action_pressed("debug_hyper_speed"):
		max_speed = 400
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# get direction from head
	var basis = transform.basis
	if head:
		basis = head.transform.basis
	var input_dir = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	var direction = (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var vel: Vector2 = Vector2(velocity.x, velocity.z)
	
	if direction:
		var acc = ACC
		if not is_on_floor():
			acc = ACC_AIR
		
		# allows quick turning
		var turn_factor = Vector2(direction.x, direction.z).angle_to(vel) / PI
		turn_factor = turn_factor ** 2
		acc += turn_factor * ACC_TURN
		
		var desired_vel = Vector2(direction.x, direction.z) * max_speed
		var diff = desired_vel - vel
		var vel_delta = diff.normalized() * acc
		
		if (abs(vel_delta.x) >= abs(diff.x)) && (abs(vel_delta.y) >= abs(diff.y)):
			vel = desired_vel
		else:
			vel += vel_delta

	else:
		var friction = FRICTION
		if not is_on_floor():
			friction = FRICTION_AIR
		
		if vel.length() > friction:
			vel -= vel.normalized() * friction
		else:
			vel = Vector2.ZERO
	
	velocity.x = vel.x
	velocity.z = vel.y
	move_and_slide()
