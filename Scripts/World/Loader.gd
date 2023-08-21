extends Node

@export var load_distance: int = 5
@export var chunk_size: int = 16

var Chunks = preload("res://Scripts/World/Chunks.gd").new(chunk_size)
var Generator = preload("res://Scripts/World/Generator.gd").new()


func generate_world():
	print("Generating world")
	for x in range(-load_distance, load_distance):
		for y in range(-load_distance, load_distance):
			for z in range(-load_distance, load_distance):
				var pos = Vector3i(x, y, z)
				print(pos)
				_generate_chunk(pos)
				_load_chunk(pos)


func _load_block(block: String, pos: Vector3):
	if block == "air":
		return
	var node = Blocks.get_block(block)
	node.transform.origin = pos
	add_child(node)


func _load_chunk(chunk_pos: Vector3i):
	var chunk = Chunks.get_chunk(chunk_pos)
	var basis = chunk_pos * chunk_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var block_pos = Vector3i(x, y, z)
				_load_block(chunk[x][y][z], block_pos + basis)


func _generate_chunk(chunk_pos: Vector3i):
	var chunk = Chunks.get_chunk(chunk_pos)
	var basis = chunk_pos * chunk_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var block_pos = Vector3i(x, y, z)
				var block = Generator.block_at(block_pos + basis)
				chunk[x][y][z] = block
