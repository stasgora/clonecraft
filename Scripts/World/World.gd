extends Node3D

@export var block_scene: PackedScene


func _spawn_block(pos: Vector3):
	var block: Node3D = Blocks.get_block("andesite")
	block.transform.origin = pos
	add_child(block)


func geterate_world():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

	var size: int = 50
	for x in range(-size, size):
		for z in range(-size, size):
			var y = noise.get_noise_2d(x, z)
			y = (y - 1) * 20
			_spawn_block(Vector3(x, roundi(y), z))
