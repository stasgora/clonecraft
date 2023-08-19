extends Node

var block_material: StandardMaterial3D = preload("res://Assets/Materials/Block.tres")

enum Type {
	STONE,
	DIRT,
	BARREL_TOP_OPEN
}

var materials: Dictionary = {}

func _load_material(type: Type):
	var name = Type.keys()[type].to_lower()
	var material = block_material.duplicate()
	material.albedo_texture = load("res://Textures/Blocks/%s.png" % name)
	return material

func _load_materials():
	print('Loading materials')
	for type in Type.values():
		materials[type] = _load_material(type)

func material(type: Type):
	if materials.is_empty():
		_load_materials()
	return materials[type]
