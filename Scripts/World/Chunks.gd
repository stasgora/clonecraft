extends Node


var _chunks: Dictionary = {}
var size: int = 16


func get_chunk(index: Vector3i) -> Dictionary:
	if index not in _chunks:
		_chunks[index] = {}
	return _chunks[index]


func get_block_pos_in_chunk(world_pos: Vector3i) -> Vector3i:
	return Vector3i(
		world_pos.x % size,
		world_pos.y % size,
		world_pos.z % size,
	)


func get_chunk_index(world_pos: Vector3i) -> Vector3i:
	return world_pos / size


func get_chunk_pos(index: Vector3i) -> Vector3i:
	return index * size


func get_block(pos: Vector3i) -> Block:
	var chunk = get_chunk(get_chunk_index(pos))
	return chunk[get_block_pos_in_chunk(pos)]


func get_chunk_content(index: Vector3i) -> Dictionary:
	var content: Dictionary = {}
	var chunk = get_chunk(index)
	for block_pos in chunk:
		var block: Block = chunk[block_pos]
		if block.name not in content:
			content[block.name] = []
		content[block.name].append(block_pos)
	return content
