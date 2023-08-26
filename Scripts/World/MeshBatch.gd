class_name MeshBatch


var block: String
var batch = MultiMeshInstance3D.new()
const _basis = Basis()


func _init(block_name: String):
	block = block_name

	var multi_mesh = MultiMesh.new()
	multi_mesh.mesh = Blocks.get_block(block)
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	batch = MultiMeshInstance3D.new()
	batch.multimesh = multi_mesh
	batch.name = block


func add_meshes(positions: Array, base_pos: Vector3i):
	var transforms = batch.multimesh.transform_array
	for pos in positions:
		var transform = [_basis.x, _basis.y, _basis.z, pos + base_pos]
		transforms += PackedVector3Array(transform)
	batch.multimesh.instance_count += positions.size()
	batch.multimesh.transform_array = transforms
