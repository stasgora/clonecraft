extends Node


var _chunks: Dictionary = {}
var _chunk_size: int
var _chunk_blueprint: Array


func _sized_array(size: int):
	var array = Array()
	array.resize(size)
	return array


func _init(size: int):
	_chunk_size = size
	_chunk_blueprint = _sized_array(_chunk_size)
	for x in _chunk_size:
		_chunk_blueprint[x] = _sized_array(_chunk_size)
		for y in _chunk_size:
			_chunk_blueprint[x][y] = _sized_array(_chunk_size)


func get_chunk(pos: Vector3i):
	if pos not in _chunks:
		_chunks[pos] = _chunk_blueprint.duplicate()
	return _chunks[pos]


func get_chunk_content(pos: Vector3i):
	var content: Dictionary = {}
	var chunk = get_chunk(pos)
	for x in range(_chunk_size):
		for y in range(_chunk_size):
			for z in range(_chunk_size):
				var block = chunk[x][y][z]
				if block not in content:
					content[block] = []
				content[block].append(Vector3i(x, y, z))
	return content
