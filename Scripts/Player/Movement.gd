extends CharacterBody3D


@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_speed: float = 4
var flying: bool = false
var processing: bool = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_delta: Vector2 = Vector2.ZERO

func _input(event):
	if not processing:
		return
	if event is InputEventMouseMotion:
		mouse_delta += event.relative


func _get_movement_direction():
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	var player_transform = transform
	if flying:
		player_transform = transform.rotated_local(Vector3.RIGHT, $Head.rotation.x)
	direction = (player_transform.basis * direction).normalized()
	if flying:
		direction.y += Input.get_axis("fly_down", "fly_up")
	return direction


func _update_velocity(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction = _get_movement_direction()
	if direction:
		velocity.x = direction.x * speed
		if flying:
			velocity.y = direction.y * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if flying:
			velocity.y = move_toward(velocity.y, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if not is_on_floor() and not flying:
		velocity.y -= gravity * delta


func _rotate_player(delta):
	var rotation_change = delta * -mouse_delta * mouse_speed
	rotate_y(deg_to_rad(rotation_change.x))
	$Head.rotate_x(deg_to_rad(rotation_change.y))
	$Head.rotation.x = clamp($Head.rotation.x, -PI/2, PI/2)
	mouse_delta = Vector2.ZERO


func _physics_process(delta):
	if not processing:
		return

	if Input.is_action_just_pressed("fly_trigger"):
		flying = !flying
		print('Flying: %s' % flying)

	_rotate_player(delta)
	_update_velocity(delta)
	move_and_slide()


func _on_menu_toggled(open: bool):
	processing = not open
