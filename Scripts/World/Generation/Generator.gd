class_name Generator

var _map: NoiseMap


func _init(world_seed = null):
	var seed = world_seed if world_seed else randi()
	_map = NoiseMap.new(seed)


func block_at(pos: Vector3i) -> String:
	var y = _map.get_noise_at(Vector2i(pos.x, pos.z))
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
