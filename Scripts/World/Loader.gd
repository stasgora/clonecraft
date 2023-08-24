extends Node

@export var load_distance: int = 5
@export var chunk_size: int = 16
var _mesh_map: Dictionary = {}

var Chunks = preload("res://Scripts/World/Chunks.gd").new(chunk_size)
var Generator = preload("res://Scripts/World/Generator.gd").new()


func generate_world():
	print("Generating world")
	for x in range(-load_distance, load_distance + 1):
		for y in range(-load_distance, load_distance + 1):
			for z in range(-load_distance, load_distance + 1):
				var pos = Vector3i(x, y, z)
				print("Generating " + str(pos))
				_generate_chunk(pos)
				_load_chunk(pos)


func _get_multimesh(block: String):
	if block not in _mesh_map:
		var mesh = MultiMesh.new()
		mesh.mesh = Blocks.get_block(block)
		mesh.transform_format = MultiMesh.TRANSFORM_3D
		_mesh_map[block] = MultiMeshInstance3D.new()
		_mesh_map[block].multimesh = mesh
		_mesh_map[block].name = block
		add_child(_mesh_map[block])
	return _mesh_map[block]


func _load_chunk(chunk_pos: Vector3i):
	var base_pos = chunk_pos * chunk_size
	var basis = Basis()
	var content = Chunks.get_chunk_content(chunk_pos)
	for block in content:
		if block == "air":
			continue
		var mesh = _get_multimesh(block)
		var transforms = mesh.multimesh.transform_array
		for pos in content[block]:
			var transform = [basis.x, basis.y, basis.z, pos + base_pos]
			transforms += PackedVector3Array(transform)
		mesh.multimesh.instance_count += content[block].size()
		mesh.multimesh.transform_array = transforms


func _generate_chunk(chunk_pos: Vector3i):
	var chunk = Chunks.get_chunk(chunk_pos)
	var base_pos = chunk_pos * chunk_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var block_pos = Vector3i(x, y, z)
				var block = Generator.block_at(block_pos + base_pos)
				chunk[x][y][z] = block
