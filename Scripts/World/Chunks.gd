extends Node


var _chunks: Dictionary = {}
var _chunk_size: int


func _init(size: int):
	_chunk_size = size


func get_chunk(pos: Vector3i) -> Dictionary:
	if pos not in _chunks:
		_chunks[pos] = {}
	return _chunks[pos]


func get_block_chunk_pos(world_pos: Vector3i) -> Vector3i:
	return Vector3i(
		world_pos.x % _chunk_size,
		world_pos.y % _chunk_size,
		world_pos.z % _chunk_size,
	)


func get_chunk_pos(world_pos: Vector3i) -> Vector3i:
	return world_pos / _chunk_size


func get_block(pos: Vector3i) -> Block:
	var chunk = get_chunk(get_chunk_pos(pos))
	return chunk[get_block_chunk_pos(pos)]


func get_chunk_content(pos: Vector3i) -> Dictionary:
	var content: Dictionary = {}
	var chunk = get_chunk(pos)
	for block_pos in chunk:
		var block: Block = chunk[block_pos]
		if block.name not in content:
			content[block.name] = []
		content[block.name].append(block_pos)
	return content
