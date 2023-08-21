extends Node

var block_scene: PackedScene = preload("res://Scenes/Block.tscn")

const _model_path = "models/block"
const _texture_path = "textures/block"
var _models: Dictionary = {}
var _materials: Dictionary = {}

enum BlockSceneSides {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	FRONT,
	BACK
}

var _model_texture_map = {
	'all': [
		BlockSceneSides.FRONT,
		BlockSceneSides.RIGHT,
		BlockSceneSides.LEFT,
		BlockSceneSides.BACK,
		BlockSceneSides.TOP,
		BlockSceneSides.BOTTOM
	],
	'side': [
		BlockSceneSides.FRONT,
		BlockSceneSides.RIGHT,
		BlockSceneSides.LEFT,
		BlockSceneSides.BACK,
	],
	'end': [BlockSceneSides.TOP, BlockSceneSides.BOTTOM],
	'front': [BlockSceneSides.FRONT],
	'back': [BlockSceneSides.BACK],
	'top': [BlockSceneSides.TOP],
	'bottom': [BlockSceneSides.BOTTOM],
	'north': [BlockSceneSides.FRONT],
	'south': [BlockSceneSides.BACK],
	'east': [BlockSceneSides.LEFT],
	'west': [BlockSceneSides.RIGHT],
	'up': [BlockSceneSides.TOP],
	'down': [BlockSceneSides.BOTTOM],
}

func _load_material(mat_name: String) -> StandardMaterial3D:
	if mat_name in _materials:
		return _materials[mat_name]
	var material = StandardMaterial3D.new()
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	var path = "%s/%s.png" % [_texture_path, mat_name]
	material.albedo_texture = ResourcePackManager.load_texture(path)
	_materials[mat_name] = material
	return material


func _is_tinted(config: Dictionary, slot: String) -> bool:
	if "parent" in config and "block/leaves" in config["parent"]:
		return true
	if "elements" not in config:
		return false
	for element in config["elements"]:
		for face in element["faces"].values():
			if face["texture"] == "#" + slot and "tintindex" in face:
				return true
	return false


func _load_model(model_name: String) -> void:
	var model_path = "%s/%s.json" % [_model_path, model_name]
	var config = ResourcePackManager.load_json(model_path)
	
	if "textures" not in config:
		return
	var texture_slots = config["textures"].keys()
	texture_slots.erase("particle")
	texture_slots.erase("overlay")
	if not _model_texture_map.has_all(texture_slots):
		return

	var block: Node3D = block_scene.instantiate()
	var mesh: MeshInstance3D = block.get_node("Mesh")
	for slot in texture_slots:
		for side in _model_texture_map[slot]:
			var side_value = config["textures"][slot]
			if "block/" not in side_value:
				return
			var texture = side_value.split("/")[1]
			var model_material = _load_material(texture)
			if _is_tinted(config, slot):
				model_material.albedo_color = Color(.35, .6, .22, 1)
			mesh.set_surface_override_material(side, model_material)

	_models[model_name] = block


func load_models():
	print('Loading block models')
	var blocks = ResourcePackManager.list_files(_model_path)
	for file in blocks:
		_load_model(file.get_basename())


func get_block(model_name: String) -> Node3D:
	assert(model_name in _models, "Model %s does not exist" % model_name)
	return _models[model_name].duplicate()
