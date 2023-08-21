extends Node3D

var _noise = FastNoiseLite.new()


func _init(selected_seed = null):
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.seed = selected_seed or randi()


func block_at(pos: Vector3i) -> String:
	var y = _noise.get_noise_2d(pos.x, pos.z)
	y = roundi((y - 1) * 20)
	if pos.y > y:
		return "air"
	if pos.y == y:
		return "grass_block"
	if pos.y > y - 4:
		return "dirt"
	if randf() < .05:
		return "coal_ore"
	return "stone"
