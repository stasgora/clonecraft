class_name MeshBatch


var name: String
var batch = MultiMeshInstance3D.new()
const _basis = Basis()


func _init(block_name: String):
	name = block_name

	var multi_mesh = MultiMesh.new()
	multi_mesh.mesh = Blocks.get_block(name)
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	batch = MultiMeshInstance3D.new()
	batch.multimesh = multi_mesh
	batch.name = name


func load_meshes(positions: Array):
	var transforms = batch.multimesh.transform_array
	var old_count = batch.multimesh.instance_count
	var count = 0
	for pos in positions:
		var block: Block = Chunks.get_block(pos)
		if block.mesh_index >= 0:
			print('Block at %s already has a mesh' % pos)
			continue
		block.mesh_index = old_count + count
		var transform = [_basis.x, _basis.y, _basis.z, pos]
		transforms += PackedVector3Array(transform)
		count += 1
	batch.multimesh.instance_count += count
	batch.multimesh.transform_array = transforms


func _get_block_pos(index: int) -> Vector3i:
	var transforms = batch.multimesh.transform_array
	return transforms[index * 4 + 3]


func unload_meshes(positions: Array):
	var transforms = batch.multimesh.transform_array
	var count = batch.multimesh.instance_count
	for pos in positions:
		var block: Block = Chunks.get_block(pos)
		if block.mesh_index == -1:
			print('Block at %s does not have a mesh' % pos)
			continue
		var last = count - 1
		if block.mesh_index < last:
			for i in range(4):
				transforms[block.mesh_index * 4 + i] = transforms[last * 4 + i]
			var last_pos = _get_block_pos(last)
			Chunks.get_block(last_pos).mesh_index = block.mesh_index
		count -= 1
		block.mesh_index = -1
	batch.multimesh.instance_count = count
	batch.multimesh.transform_array = transforms.slice(0, count * 4)	
