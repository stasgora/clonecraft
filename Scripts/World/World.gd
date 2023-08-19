extends Node3D

@export var block_scene: PackedScene


func spawn_block(position: Vector3):
	var block: Node3D = block_scene.instantiate()
	var mesh: MeshInstance3D = block.get_node("Mesh")
	mesh.material_override = Blocks.material(Blocks.Type.DIRT)
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
			spawn_block(Vector3(x, roundi(y), z))
