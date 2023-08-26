extends Node

@export var load_distance: int = 5
var _mesh_map: Dictionary = {}

var generator = Generator.new()


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


func _load_chunk(index: Vector3i):
	var base_pos = Chunks.get_chunk_pos(index)
	var content = Chunks.get_chunk_content(index)
	for block in content:
		if block == "air":
			continue
		for pos in content[block]:
			add_child(_create_block_collider(pos + base_pos))
		var batch: MeshBatch = _get_mesh_batch(block)
		batch.add_meshes(content[block], base_pos)


func _generate_chunk(index: Vector3i):
	var chunk = Chunks.get_chunk(index)
	var base_pos = Chunks.get_chunk_pos(index)
	for x in range(Chunks.size):
		for y in range(Chunks.size):
			for z in range(Chunks.size):
				var block_pos = Vector3i(x, y, z)
				var block = generator.block_at(block_pos + base_pos)
				chunk[block_pos] = Block.new(block)
