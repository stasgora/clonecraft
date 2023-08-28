extends Node

@export var load_distance: int = 5
var _mesh_map: Dictionary = {}

var generator = Generator.new()
var collider = preload("res://Scenes/Collider.tscn")


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


func _load_block_collider(pos: Vector3i):
	var block = collider.instantiate()
	block.position = pos
	add_child(block)


func _load_chunk(index: Vector3i):
	var base_pos = Chunks.get_chunk_pos(index)
	var content = Chunks.get_chunk_content(index)
	for block in content:
		if block == "air":
			continue
		for i in range(content[block].size()):
			var block_pos = content[block][i] + base_pos
			content[block][i] = block_pos
			_load_block_collider(block_pos)
		var batch: MeshBatch = _get_mesh_batch(block)
		batch.load_meshes(content[block])


func remove_block(pos: Vector3i):
	if not Chunks.block_exists(pos):
		print('No block exists at %s' % pos)
		return
	var block = Chunks.get_block(pos)
	_get_mesh_batch(block.name).unload_meshes([pos])
	block.collider.queue_free()
	Chunks.remove_block(pos)


func place_block(block: String, pos: Vector3i):
	if Chunks.block_exists(pos):
		print('Block already exists at %s' % pos)
		return
	Chunks.place_block(Block.new(block), pos)
	_get_mesh_batch(block).load_meshes([pos])
	_load_block_collider(pos)


func _generate_chunk(index: Vector3i):
	var base_pos = Chunks.get_chunk_pos(index)
	for x in range(Chunks.size):
		for y in range(Chunks.size):
			for z in range(Chunks.size):
				var block_pos = Vector3i(x, y, z) + base_pos
				var block = generator.block_at(block_pos)
				if block == "air":
					continue
				Chunks.place_block(Block.new(block), block_pos)
