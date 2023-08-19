extends Node

var block_material: StandardMaterial3D = preload("res://Assets/Materials/Block.tres")

enum Type {
	STONE,
	DIRT
}

var materials: Dictionary = {}

func load_material(type: Type):
	var name = Type.keys()[type].to_lower()
	var image = Image.load_from_file("res://Textures/Blocks/%s.png" % name)
	var material = block_material.duplicate()
	material.albedo_texture = ImageTexture.create_from_image(image)
	return material

func load_materials():
	print('Loading materials')
	for type in Type.values():
		materials[type] = load_material(type)

func material(type: Type):
	if materials.is_empty():
		load_materials()
	return materials[type]
