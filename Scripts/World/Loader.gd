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


func _get_mesh_batch(block: String):
	if block not in _mesh_map:
		_mesh_map[block] = MeshBatch.new(block)
		add_child(_mesh_map[block].batch)
	return _mesh_map[block]


func _create_block_collider(pos: Vector3i):
	var collider = StaticBody3D.new()
	var shape = CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	collider.transform = Transform3D(Basis(), pos)
	collider.add_child(shape)
	return collider


func _load_chunk(chunk_pos: Vector3i):
	var base_pos = chunk_pos * chunk_size
	var content = Chunks.get_chunk_content(chunk_pos)
	for block in content:
		if block == "air":
			continue
		for pos in content[block]:
			add_child(_create_block_collider(pos + base_pos))
		var batch: MeshBatch = _get_mesh_batch(block)
		batch.add_meshes(content[block], base_pos)


func _generate_chunk(chunk_pos: Vector3i):
	var chunk = Chunks.get_chunk(chunk_pos)
	var base_pos = chunk_pos * chunk_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var block_pos = Vector3i(x, y, z)
				var block = Generator.block_at(block_pos + base_pos)
				chunk[block_pos] = Block.new(block)
