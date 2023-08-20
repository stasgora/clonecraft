extends Node3D


func spawn_block(block: String, pos: Vector3):
	var node = Blocks.get_block(block)
	node.transform.origin = pos
	add_child(node)


func generate_world():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

	var size: int = 50
	for x in range(-size, size):
		for z in range(-size, size):
			var y = noise.get_noise_2d(x, z)
			y = (y - 1) * 20
			spawn_block("grass_block", Vector3(x, roundi(y), z))
