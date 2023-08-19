extends Node3D

@export var block_scene: PackedScene


func _spawn_block(position: Vector3):
	var block: Node3D = block_scene.instantiate()
	var mesh: MeshInstance3D = block.get_node("Mesh")
	for i in range(6):
		mesh.set_surface_override_material(i, Blocks.material(Blocks.Type.BARREL_TOP_OPEN))
	mesh.set_surface_override_material(0, Blocks.material(Blocks.Type.DIRT))
	block.transform.origin = position
	add_child(block)

func _ready():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

	var size: int = 50
	for x in range(-size, size):
		for z in range(-size, size):
			var y = noise.get_noise_2d(x, z)
			y = (y - 1) * 20
			_spawn_block(Vector3(x, roundi(y), z))
