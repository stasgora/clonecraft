extends Node

var _current_pack: String


func load_resource_pack(pack_name: String):
	_current_pack = pack_name


func _get_path(path: String) -> String:
	return "res://ResourcePacks/%s/assets/minecraft/%s" % [_current_pack, path]


func _open_file(path: String) -> FileAccess:
	var file = FileAccess.open(_get_path(path), FileAccess.READ)
	assert(file != null, "Could not open file %s, %s" % [path, FileAccess.get_open_error()])
	return file


func load_json(path: String) -> Dictionary:
	var file = _open_file(path)
	return JSON.parse_string(file.get_as_text())


func load_texture(path: String) -> Texture2D:
	return load(_get_path(path))


func list_files(path: String) -> PackedStringArray:
	return DirAccess.get_files_at(_get_path(path))
