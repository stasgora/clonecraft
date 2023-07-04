extends CharacterBody3D


@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_speed: float = 4

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_delta: Vector2 = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func _physics_process(delta):
	rotate_y(deg_to_rad(delta * -mouse_delta.x * mouse_speed))
	$Center/Crane.rotate_x(deg_to_rad(delta * -mouse_delta.y * mouse_speed))
	mouse_delta = Vector2.ZERO

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
