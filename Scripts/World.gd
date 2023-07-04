extends Node


@export var block_scene: PackedScene

func spawn_block(position: Vector3):
	var block: Node3D = block_scene.instantiate()
	block.transform.origin = position
	add_child(block)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var size: int = 5
	for x in range(-size, size):
		for z in range(-size, size):
			spawn_block(Vector3(x, -1, z))


func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
