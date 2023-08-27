extends Node


var _chunks: Dictionary = {}
var size: int = 16


func _get_chunk(index: Vector3i) -> Dictionary:
	if index not in _chunks:
		_chunks[index] = {}
	return _chunks[index]


func get_block_pos_in_chunk(world_pos: Vector3i) -> Vector3i:
	return Vector3i(
		Utils.mod(world_pos.x, size),
		Utils.mod(world_pos.y, size),
		Utils.mod(world_pos.z, size),
	)


func get_chunk_index(world_pos: Vector3i) -> Vector3i:
	return Vector3i(
		floori(world_pos.x / float(size)),
		floori(world_pos.y / float(size)),
		floori(world_pos.z / float(size)),
	)


func place_block(block: Block, pos: Vector3i):
	var chunk = _get_chunk(get_chunk_index(pos))
	chunk[get_block_pos_in_chunk(pos)] = block


func remove_block(pos: Vector3i):
	var chunk = _get_chunk(get_chunk_index(pos))
	chunk.erase(get_block_pos_in_chunk(pos))


func block_exists(pos: Vector3i):
	var chunk = _get_chunk(get_chunk_index(pos))
	return get_block_pos_in_chunk(pos) in chunk


func get_chunk_pos(index: Vector3i) -> Vector3i:
	return index * size


func get_block(pos: Vector3i) -> Block:
	var chunk = _get_chunk(get_chunk_index(pos))
	return chunk.get(get_block_pos_in_chunk(pos))


func get_chunk_content(index: Vector3i) -> Dictionary:
	var content: Dictionary = {}
	var chunk = _get_chunk(index)
	for block_pos in chunk:
		var block: Block = chunk[block_pos]
		if block.name not in content:
			content[block.name] = []
		content[block.name].append(block_pos)
	return content
