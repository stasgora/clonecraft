extends Node


var _chunks: Dictionary = {}
var _chunk_size: int


func _init(size: int):
	_chunk_size = size


func _sized_array(size: int):
	var array = Array()
	array.resize(size)
	return array


func get_chunk(pos: Vector3i):
	if pos not in _chunks:
		_create_chunk(pos)
	return _chunks[pos]


func _create_chunk(pos: Vector3i):
	_chunks[pos] = _sized_array(_chunk_size)
	for x in _chunk_size:
		_chunks[pos][x] = _sized_array(_chunk_size)
		for y in _chunk_size:
			_chunks[pos][x][y] = _sized_array(_chunk_size)
