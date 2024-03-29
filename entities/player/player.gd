extends Playable

const SPEED = 10.0
const SPEED_RUN = 40.0
const JUMP_VELOCITY = 4.5

@onready var body = $CharacterBody
@onready var camera = $CharacterBody/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not body.is_on_floor():
		body.velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and body.is_on_floor():
		body.velocity.y = JUMP_VELOCITY
	
	var speed = SPEED
	# run
	if Input.is_action_pressed("ui_shift"):
		speed = SPEED_RUN

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		body.velocity.x = direction.x * speed
		body.velocity.z = direction.z * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
		body.velocity.z = move_toward(body.velocity.z, 0, speed)

	body.move_and_slide()


func start():
	print("starting")
	camera.make_current()
