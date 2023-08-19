extends Node

signal menu_toggled(open: bool)
var menu_open: bool = false

@export var block_scene: PackedScene

func spawn_block(position: Vector3):
	var block: Node3D = block_scene.instantiate()
	block.transform.origin = position
	add_child(block)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

	var size: int = 50
	for x in range(-size, size):
		for z in range(-size, size):
			var y = noise.get_noise_2d(x, z)
			y = (y - 1) * 20
			spawn_block(Vector3(x, roundi(y), z))

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		menu_open = !menu_open
		menu_toggled.emit(menu_open)
		$MenuOverlay.visible = menu_open
		$GameOverlay.visible = !menu_open
		
		var mouse_mode = Input.MOUSE_MODE_VISIBLE if menu_open else Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(mouse_mode)
		#$Player.set_process(!menu_open)
		#$Player.set_physics_process(!menu_open)

